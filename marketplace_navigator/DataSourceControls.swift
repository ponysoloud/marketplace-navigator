//
//  DataSourceControls.swift
//  marketplace_navigator
//
//  Created by Александр Пономарев on 09.10.17.
//  Copyright © 2017 Base team. All rights reserved.
//

import Foundation
import CoreLocation

protocol DataSourceControls {
    
    func saveInMemory()
    
    func removeFromMemory()
    
    func checkMemory() -> Bool
    
    func loadUser(completion: @escaping (Bool, BadResponse?)->Void)
    
    func loadUser(email: String, password: String, completion: @escaping (Bool, BadResponse?)->Void)
    
    func createUser(email: String, password: String, name: String, gender: Gender, completion: @escaping (Bool, BadResponse?)->Void)
    
    func getItems(by location: CLLocation, completion: @escaping (Bool) -> Void)
    
    func likeItem(host: String, shop: String, item: String, completion: @escaping (Bool) -> Void)
    
    func removeLiked(item: String, completion: @escaping (Bool) -> Void)
}
