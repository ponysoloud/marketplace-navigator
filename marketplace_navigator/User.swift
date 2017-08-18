//
//  User.swift
//  marketplace_navigator
//
//  Created by Александр Пономарев on 02.08.17.
//  Copyright © 2017 Base team. All rights reserved.
//

import Foundation
import CoreLocation

class User: GoodResponse {
    
    override class func create(params: [String: Any], json: [String:Any]) -> User {
        
        guard let type = json["usertype"] as? String else {
            fatalError("Invalid json response")
        }
        
        switch type {
        case "seller":
            return SellerUser(params: params, json: json)
        case "customer":
            return CustomerUser(params: params, json: json)
        default:
            fatalError("Invalid json response")
        }
        
    }
    
    var idToken: String = ""
    var name: String = ""
    var image: String = ""
    var location: Location?
    
    var email: String = ""
    var password: String = ""
    
    
    init (params: [String: Any], json: [String:Any]) {
        
        if let email = params["email"] as? String {
            self.email = email
        }
        
        if let password = params["password"] as? String {
            self.password = password
        }
        
        if let idToken = json["idToken"] as? String {
            self.idToken = idToken
        }
        
        if let name = json["name"] as? String {
            self.name = name
        }
        
        if let image = json["image"] as? String {
            self.image = image
        }
        
        if let location = json["location"] as? [String: Any] {
            self.location = Location(location)
        }
    }
    
    func toDictionary() -> [String: Any] {
        
        let json : [String: Any] =
            [
                "email": email,
                "password": password
        ]
        
        return json
    }

    
}
