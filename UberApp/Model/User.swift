//
//  User.swift
//  UberApp
//
//  Created by Salma Hassan on 3/26/20.
//  Copyright © 2020 salma. All rights reserved.
//

import Foundation
import CoreLocation

struct User {
    let fullName: String
    let email: String
    let accountType: Int
    let uid: String
    var location: CLLocation?
    
    init(uid: String, dictionary: [String : Any]) {
        self.uid = uid
        fullName = dictionary["fullName"] as? String ?? ""
        email = dictionary["email"] as? String ?? ""
        accountType = dictionary["accountType"] as? Int ?? 0
    }
}
