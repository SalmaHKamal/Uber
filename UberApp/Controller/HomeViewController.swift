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

class HomeViewController: UIViewController {
    
    // MARK: - Properties
    private let mapView = MKMapView()
    
    // MARK: - LifeCylce
    override func viewDidLoad() {
        isUserLoggedIn()
    }
    
    // MARK: - Helper Methods
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
        view.addSubview(mapView)
        mapView.frame = view.frame
    }
}
