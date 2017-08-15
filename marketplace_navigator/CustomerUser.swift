//
//  CustomerUser.swift
//  marketplace_navigator
//
//  Created by Александр Пономарев on 02.08.17.
//  Copyright © 2017 Base team. All rights reserved.
//

import Foundation

class CustomerUser: User {
    
    var gender: Gender = .Male
    
    override init(params: [String: Any], json: [String : Any]) {
        
        if let gender = json["gender"] as? String {
            self.gender = Gender(rawValue: gender)!
        }
        
        super.init(params: params, json: json)
        
    }
    
}
