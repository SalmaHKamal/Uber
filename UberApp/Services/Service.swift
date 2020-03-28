//
//  Service.swift
//  UberApp
//
//  Created by Salma Hassan on 3/26/20.
//  Copyright © 2020 salma. All rights reserved.
//

import Foundation
import Firebase
import GeoFire

let DB_REF = Database.database().reference()
let USERS_REF = DB_REF.child("users")
let DRIVER_LOC = DB_REF.child("driver-locations")

struct Service {
    
    static let shared = Service()
    
    func fetchUserData(uid: String, completion: @escaping(User) -> Void){
        USERS_REF.child(uid).observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionary = snapshot.value as? [String : Any] else { return }
            completion(User(uid: snapshot.key , dictionary: dictionary))
        }
    }
    
    func fetchDriverData(location: CLLocation, completion: @escaping(User) -> Void){
        let geofire = GeoFire(firebaseRef: DRIVER_LOC)
        
        DRIVER_LOC.observe(.value) { (snapshot) in
            geofire.query(at: location, withRadius: 50).observe(.keyEntered, with: { (uid, location) in
                Service.shared.fetchUserData(uid: uid, completion: { (user) in
                    var driver = user
                    driver.location = location
                    completion(driver)
                })
            })
        }
    }
}
