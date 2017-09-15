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
    
    var likedItems = CustomStorage<ItemCard>()
    
    var location: Location?
    
    override init(params: [String: Any], json: [String : Any]) {
        
        if let gender = json["gender"] as? String {
            self.gender = Gender(rawValue: gender)!
        }
        
        if let items = json["liked"] as? [String: Any] {
            self.likedItems = CustomStorage<ItemCard>(json: items)
        }
        
        if let location = json["location"] as? [String: Any] {
            self.location = Location(location)
        }
        
        super.init(params: params, json: json)
        
    }
    
}
