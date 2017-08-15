//
//  SellerUser.swift
//  marketplace_navigator
//
//  Created by Александр Пономарев on 02.08.17.
//  Copyright © 2017 Base team. All rights reserved.
//

import Foundation

class SellerUser: User {
    
    var items: ItemStore = ItemStore()
    
    override init(params: [String: Any], json: [String : Any]) {
        
        if let items = json["goods"] as? [String: Any] {
            self.items = ItemStore(json: items)
        }
        
        super.init(params: params, json: json)
    }
    
}
