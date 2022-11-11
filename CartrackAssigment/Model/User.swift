//
//  User.swift
//  CartrackAssigment
//
//  Created by Tejas Nanavati on 08/11/22.
//

import Foundation

class User: NSObject {
    var id: Int
    var name: String
    var username: String
    var email: String
    var address: Address
    var phone: String?
    var website: String?
    var company: Company?
    
    
    
    
    init?(json: [String : Any]?) {
        if let id = json?["id"] as? Int,
           let name = json?["name"] as? String,
           let username = json?["username"] as? String,
           let email = json?["email"] as? String,
           let addressData = json?["address"] as? [String: Any],
           let address = Address(json: addressData) {
            self.id = id
            self.name = name
            self.username = username
            self.email = email
            self.address = address
        } else {
            return nil
        }
        
        self.phone = json?["phone"] as? String
        self.website = json?["website"] as? String
        self.company = Company(json: json?["company"] as? [String: Any])
    }
    
    
}

