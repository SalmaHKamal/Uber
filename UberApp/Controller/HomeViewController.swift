//
//  HomeViewController.swift
//  UberApp
//
//  Created by Salma Hassan on 3/25/20.
//  Copyright © 2020 salma. All rights reserved.
//

import UIKit
import Firebase
import MapKit

private let reuseIdentifier = "Cell"
private let driverAnnotation = "DriverAnnotation"
enum ActionButtonConfiguration {
    case dismissal
    case openMenu
    
    init() {
        self = .openMenu
    }
}


class HomeViewController: UIViewController {
    
    // MARK: - Properties
    private var searchResults = [MKPlacemark]()
    private let mapView = MKMapView()
    private let locationManager = LocationHandler.shared.locationManager
    private let whereToView = WhereToView()
    private let searchLlocationView = SearchLocationView()
    private let tableView = UITableView()
    private let topLocationViewHeight : CGFloat = 200
    var user : User?{
        didSet{
            searchLlocationView.user = user
        }
    }
    private var actionButtonConfig = ActionButtonConfiguration()
    
    private let actionButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "baseline_menu_black_36dp").withRenderingMode(.alwaysOriginal), for: .normal)
        btn.addTarget(self, action: #selector(actionButtonPressed), for: .touchUpInside)
        return btn
    }()
    
    
    // MARK: - LifeCylce
    func configure() {
        configUI()
        setupTableView()
        fetchUserData()
        fetchDriverData()
    }
    
    override func viewDidLoad() {
        isUserLoggedIn()
        enableLocationService()
        configure()
    }
    
    // MARK: - APi calls
    func fetchUserData(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Service.shared.fetchUserData(uid: uid) { (user) in
            self.user = user
        }
    }
    
    func fetchDriverData(){
        guard let location = locationManager?.location else { return }
        Service.shared.fetchDriverData(location: location) { (driver) in
            
            guard let coordinate = driver.location?.coordinate else { return }
            let annotation = DriverAnnotation(uid: driver.uid, coordinate: coordinate)
            
            var driverIsVisible: Bool {
                return self.mapView.annotations.contains(where: { annotation -> Bool in
                    guard let driverAnno = annotation as? DriverAnnotation else { return false }
                    if driverAnno.uid == driver.uid {
                        driverAnno.updateAnnotationLocation(coordinate: coordinate)
                        return true
                    }
                    return false
                })
            }
            
            if !driverIsVisible {
                self.mapView.addAnnotation(annotation)
            }
        }
    }
    
    
    // MARK: - Helper Methods
    @objc func actionButtonPressed(){
        switch actionButtonConfig {
        case .dismissal:
            print("dismiss")
            UIView.animate(withDuration: 0.2) {
                self.whereToView.alpha = 1
            }
            self.actionButtonConfig = .openMenu
            actionButton.setImage(#imageLiteral(resourceName: "baseline_menu_black_36dp").withRenderingMode(.alwaysOriginal), for: .normal)
        case .openMenu:
            print("openMenu")
        }
    }
    
    func addNewAnnotation(annotation: MKAnnotation){
        mapView.addAnnotation(annotation)
    }
    
    func updateAnnotationView(annotation:DriverAnnotation){
        annotation.updateAnnotationLocation(coordinate: annotation.coordinate)
    }
    
    func isUserLoggedIn(){
        if let _ = Auth.auth().currentUser?.uid {
            configure()
        }else {
            DispatchQueue.main.async {
                let nav = UINavigationController(rootViewController: LoginViewController())
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            }
        }
    }
    
    func logOut(){
        do{
            try Auth.auth().signOut()
            DispatchQueue.main.async {
                let nav = UINavigationController(rootViewController: LoginViewController())
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            }
        }catch{
            print("Failed signing out => " , error.localizedDescription)
        }
    }
    
    func configUI(){
        setupMapView()
        setupActionButton()
        setupWhereToView()
        
    }
    
    func setupActionButton(){
        view.addSubview(actionButton)
        actionButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingLeft: 16, paddingTop: 16, width: 30, height: 30)
    }
    
    func setupMapView(){
        view.addSubview(mapView)
        mapView.delegate = self
        mapView.frame = view.frame
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        
    }
    
    func setupWhereToView(){
        view.addSubview(whereToView)
        whereToView.centerX(inView: view)
        whereToView.anchor(top: actionButton.bottomAnchor , paddingTop: 32, width: view.frame.width - 64)
        whereToView.alpha = 0
        
        UIView.animate(withDuration: 0.5) {
            self.whereToView.alpha = 1
        }
        
        whereToView.didTabWhereToGoView = { [weak self] in
            guard let safeSelf = self else { return }
            UIView.animate(withDuration: 0.2, animations: {
                safeSelf.whereToView.alpha = 0
            }) { _ in
                safeSelf.setupLocationView()
            }
        }
    }
}

// MARK: - Locations View
extension HomeViewController {
    fileprivate func dismissSearchLocationView(_ safeSelf: HomeViewController , completion:((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: 0.2, animations: {
            safeSelf.searchLlocationView.alpha = 0
            safeSelf.tableView.frame.origin.y = safeSelf.view.frame.height
            safeSelf.searchLlocationView.removeFromSuperview()
        }, completion: completion)
    }
    
    func setupLocationView(){
        view.addSubview(searchLlocationView)
        searchLlocationView.alpha = 0
        searchLlocationView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, height: 200)
        
        UIView.animate(withDuration: 0.2, animations: {
            self.searchLlocationView.alpha = 1
        }) { (_) in
            UIView.animate(withDuration: 0.3) {
                self.tableView.frame.origin.y = self.topLocationViewHeight
            }
        }
        
        searchLlocationView.didPressBackButton = { [weak self]  in
            guard let safeSelf = self else { return }
            safeSelf.dismissSearchLocationView(safeSelf)
        }
        
        searchLlocationView.didEnterData = { [unowned self] query in
            self.search(text: query) { (placemarks) in
                self.searchResults = placemarks
                self.tableView.reloadData()
            }
        }
    }
    
    func search(text: String, completion: @escaping([MKPlacemark]) -> Void){
        var results = [MKPlacemark]()
        let request = MKLocalSearch.Request()
        request.region = mapView.region
        request.naturalLanguageQuery = text
        
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            if let error = error {
                print("Error while getting search result => " , error.localizedDescription)
            }else {
                guard let response = response else { return }
                response.mapItems.forEach({ (item) in
                    results.append(item.placemark)
                })
                
                completion(results)
            }
        }
    }
    
    func setupTableView(){
        tableView.register(LocationCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        let height = view.frame.height - topLocationViewHeight
        tableView.frame = CGRect(x: 0,
                                 y: view.frame.height,
                                 width: view.frame.width,
                                 height: height)
        view.addSubview(tableView)
    }
}

// MARK: - Location Services
extension HomeViewController {
    func enableLocationService(){
        switch CLLocationManager.authorizationStatus() {
        case .restricted , .denied:
            break
        case .authorizedAlways:
            locationManager?.startUpdatingLocation()
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        case .authorizedWhenInUse:
            locationManager?.requestAlwaysAuthorization()
        case .notDetermined:
            locationManager?.requestWhenInUseAuthorization()
        default:
            break
        }
    }
}

// MARK: - TableView Delegate/Datasource
extension HomeViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .groupTableViewBackground
        return view
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 2 : searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? LocationCell
            else { return UITableViewCell() }
        if indexPath.section != 0 {
            cell.placemark = searchResults[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        handleActionButton()
        dismissSearchLocationView(self) { _  in
            let placemark = self.searchResults[indexPath.row]
            let annotation = MKPointAnnotation()
            annotation.coordinate = placemark.coordinate
            self.mapView.addAnnotation(annotation)
            self.mapView.selectAnnotation(annotation, animated: true)
        }
        
    }
    
    func handleActionButton(){
        actionButton.setImage(#imageLiteral(resourceName: "baseline_arrow_back_black_36dp-1").withRenderingMode(.alwaysOriginal), for: .normal)
        self.actionButtonConfig = .dismissal
    }
    
}

extension HomeViewController: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? DriverAnnotation {
            let view = MKAnnotationView(annotation: annotation, reuseIdentifier: driverAnnotation)
            view.image = #imageLiteral(resourceName: "chevron-sign-to-right")
            return view
        }
        
        return nil
    }
}
