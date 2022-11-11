//
//  Company.swift
//  CartrackAssigment
//
//  Created by Tejas Nanavati on 08/11/22.
//

import Foundation
class Company: NSObject {
    var name: String?
    var catchPhrase: String?
    var bs: String?
    
    init(json: [String : Any]?) {
        self.name = json?["name"] as? String
        self.catchPhrase = json?["catchPhrase"] as? String
        self.bs = json?["bs"] as? String
    }
}
