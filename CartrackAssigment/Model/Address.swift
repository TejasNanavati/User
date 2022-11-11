//
//  Address.swift
//  CartrackAssigment
//
//  Created by Tejas Nanavati on 08/11/22.
//

import Foundation
struct Geo {
    var lat: Double?
    var lng: Double?
    
    init(json: [String : String]?) {
        self.lat = Double(json?["lat"] ?? "0.0")
        self.lng = Double(json?["lng"] ?? "0.0")
    }
    
    
}

class Address: NSObject {
    var street: String
    var suite: String
    var city: String
    var zipcode: String
    var geo: Geo?
    
    init?(json: [String : Any]?) {
        if let street = json?["street"] as? String,
           let suite = json?["suite"] as? String,
           let city = json?["city"] as? String,
           let zipcode = json?["zipcode"] as? String {
            self.street = street
            self.suite = suite
            self.city = city
            self.zipcode = zipcode
        } else {
            return nil
        }
        
        self.geo = Geo(json: json?["geo"] as? [String: String])
    }
}

