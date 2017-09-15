//
//  Item.swift
//  marketplace_navigator
//
//  Created by Александр Пономарев on 09.08.17.
//  Copyright © 2017 Base team. All rights reserved.
//

import Foundation

class Item: GoodResponse, Jsonable, Comparable {
    
    var id: String = ""
    var name: String = ""
    var image: String = ""
    var gender: ItemGender = .Unisex
    var category: ItemCategory = .Shoes
    var price: String = ""
    
    
    init(name: String, gender: ItemGender, category: ItemCategory, price: String) {
        self.name = name
        self.gender = gender
        self.category = category
        self.price = price
    }
    
    required init(json: [String: Any]) {
        
        if let name = json["name"] as? String {
            self.name = name
        }
        
        if let image = json["image"] as? String {
            self.image = image
        }
        
        if let gender = json["gender"] as? String {
            self.gender = ItemGender(rawValue: gender)!
        }
        
        if let category = json["category"] as? String {
            self.category = ItemCategory(rawValue: category)!
        }
        
        if let price = json["price"] as? String {
            self.price = price
        }
    }
    
    func toDictionary() -> [String: Any] {
        let json : [String: Any] =
            [
                "name": name,
                "image": image,
                "gender": gender.rawValue,
                "category": category.rawValue,
                "price": price
        ]
        
        return json
    }
    
}
