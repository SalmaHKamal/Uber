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

class HomeViewController: UIViewController {
    
    // MARK: - Properties
    private let mapView = MKMapView()
    private let locationManager = CLLocationManager()
    private let whereToView = WhereToView()
    private let searchLlocationView = SearchLocationView()
    private let tableView = UITableView()
    private let topLocationViewHeight : CGFloat = 200
    var user : User?{
        didSet{
            searchLlocationView.user = user
        }
    }
    
    
    // MARK: - LifeCylce
    override func viewDidLoad() {
        isUserLoggedIn()
        enableLocationService()
        setupTableView()
        fetchUserData()
    }
    
    // MARK: - Helper Methods
    func fetchUserData(){
        Service.shared.fetchUserData { (user) in
            self.user = user
        }
    }
    
    func isUserLoggedIn(){
        if let _ = Auth.auth().currentUser?.uid {
            configUI()
        }else {
            DispatchQueue.main.async {
                let nav = UINavigationController(rootViewController: LoginViewController())
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            }
        }
    }
    
    func logOut(){
        do {
            try Auth.auth().signOut()
        }catch{
            print("Error while sign out => " , error.localizedDescription)
        }
    }
    
    func configUI(){
        setupMapView()
    }
    
    func setupMapView(){
        view.addSubview(mapView)
        mapView.frame = view.frame
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        setupWhereToView()
    }
    
    func setupWhereToView(){
        view.addSubview(whereToView)
        whereToView.centerX(inView: view)
        whereToView.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32, width: view.frame.width - 64)
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
            UIView.animate(withDuration: 0.2, animations: {
                safeSelf.searchLlocationView.alpha = 0
                safeSelf.tableView.frame.origin.y = safeSelf.view.frame.height
            }) { (_) in
                safeSelf.searchLlocationView.removeFromSuperview()
                UIView.animate(withDuration: 0.2) {
                    safeSelf.whereToView.alpha = 1
                }
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
extension HomeViewController : CLLocationManagerDelegate {
    func enableLocationService(){
        locationManager.delegate = self
        
        switch CLLocationManager.authorizationStatus() {
        case .restricted , .denied:
            break
        case .authorizedAlways:
            locationManager.startUpdatingLocation()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
        case .authorizedWhenInUse:
            locationManager.requestAlwaysAuthorization()
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestAlwaysAuthorization()
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
        return section == 0 ? 2 : 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? LocationCell
            else { return UITableViewCell() }
        
        return cell
    }
    
    
    
}
