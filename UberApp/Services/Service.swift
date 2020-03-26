//
//  Service.swift
//  UberApp
//
//  Created by Salma Hassan on 3/26/20.
//  Copyright © 2020 salma. All rights reserved.
//

import Foundation
import Firebase

let DB_REF = Database.database().reference()
let USERS_REF = DB_REF.child("users")

struct Service {
    
    static let shared = Service()
    
    func fetchUserData(completion: @escaping(User) -> Void){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        USERS_REF.child(uid).observe(.value) { (snapshot) in
            guard let dictionary = snapshot.value as? [String : Any] else { return }
            completion(User(dictionary: dictionary))
        }
        
        
    }
}
