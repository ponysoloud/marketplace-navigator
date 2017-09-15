//
//  ItemCard.swift
//  marketplace_navigator
//
//  Created by Александр Пономарев on 17.08.17.
//  Copyright © 2017 Base team. All rights reserved.
//

import Foundation

class ItemCard: Jsonable, Comparable {
    var item: Item!
    var id: String = "" {
        didSet {
            item.id = id
        }
    }
    var shopId: String = ""
    var hostName: String = ""
    var hostKey: String = ""
    
    public var description: String {
        return "Card: \(item.name); \(hostName);"
    }
    
    required init(json: [String: Any]){
        
        if let item = json["item"] as? [String: Any] {
            self.item = Item(json: item)
        }
        
        if let name = json["hostName"] as? String {
            self.hostName = name
        }
        
        if let key = json["hostKey"] as? String {
            self.hostKey = key
        }
        
        if let shopId = json["shopId"] as? String {
            self.shopId = shopId
        }
    }
    
}
