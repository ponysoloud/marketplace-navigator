//
//  SellerUser.swift
//  marketplace_navigator
//
//  Created by Александр Пономарев on 02.08.17.
//  Copyright © 2017 Base team. All rights reserved.
//

import Foundation

class SellerUser: User {
    
    var shops: CustomStorage = CustomStorage<Shop>()
    
    override init(params: [String: Any], json: [String : Any]) {
        
        if let shops = json["shops"] as? [String: Any] {
            self.shops = CustomStorage(json: shops)
        }
        
        super.init(params: params, json: json)
    }
    
}
