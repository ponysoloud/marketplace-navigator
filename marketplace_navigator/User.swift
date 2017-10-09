//
//  User.swift
//  marketplace_navigator
//
//  Created by Александр Пономарев on 02.08.17.
//  Copyright © 2017 Base team. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

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
    
    
    var email: String = ""
    var password: String = ""
    var profileImage: UIImage? {
        get {
            if let image = UserDefaults.standard.object(forKey: "CurrentUserProfileImage") as? NSData {
                return UIImage(data: image as Data)
            }
            
            return nil
        }
        
        set(image) {
            let saveImage = UIImagePNGRepresentation(image!) as NSData?
            UserDefaults.standard.set(saveImage, forKey: "CurrentUserProfileImage")
        }
    }
    
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
