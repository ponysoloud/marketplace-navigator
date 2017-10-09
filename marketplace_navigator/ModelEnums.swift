//
//  ModelEnums.swift
//  marketplace_navigator
//
//  Created by Александр Пономарев on 09.10.17.
//  Copyright © 2017 Base team. All rights reserved.
//

import Foundation

enum Gender: String {
    
    case Male = "male"
    
    case Female = "female"
    
}

enum ItemGender: String {
    
    case Male = "male"
    
    case Female = "female"
    
    case Unisex = "unisex"
}

enum UserType: String {
    
    case Seller = "seller"
    
    case Customer = "customer"
    
}

enum ItemCategory: String {
    
    case Underwear = "underwear"
    
    case Shoes = "shoes"
    
    case Denim = "denim"
    
    case Jackets = "jackets"
    
    case Shirts = "shirts"
    
    case Trousers = "trousers"
}

enum SearchItemCategory: String {
    
    case All = "all"
    
    case Underwear = "underwear"
    
    case Shoes = "shoes"
    
    case Denim = "denim"
    
    case Jackets = "jackets"
    
    case Shirts = "shirts"
    
    case Trousers = "trousers"
    
    static var count: Int { return SearchItemCategory.Trousers.hashValue + 1 }
}
