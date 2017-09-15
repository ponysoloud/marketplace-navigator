//
//  Shop.swift
//  marketplace_navigator
//
//  Created by Александр Пономарев on 07.09.17.
//  Copyright © 2017 Base team. All rights reserved.
//

import Foundation

class Shop: GoodResponse, Jsonable, Comparable {
    
    var id: String = ""
    
    var items: CustomStorage = CustomStorage<Item>()
    
    var location: Location?
    
    required init(json: [String: Any]) {
        
        if let items = json["goods"] as? [String: Any] {
            self.items = CustomStorage(json: items)
        }
        
        if let location = json["location"] as? [String: Any] {
            self.location = Location(location)
        }
    }
    
}
