//
//  DataSource.swift
//  marketplace_navigator
//
//  Created by Александр Пономарев on 02.08.17.
//  Copyright © 2017 Base team. All rights reserved.
//

import Foundation
import CoreLocation

enum Gender: String {
    
    case Male = "male"
    
    case Female = "female"
    
}

enum UserType: String {
    
    case Seller = "seller"
    
    case Customer = "customer"
    
}

enum ItemCategory: String {
    
    case Underwear = "underwear"
    
    case Shoes = "shoes"
    
}

enum ItemGender: String {
    
    case Male = "male"
    
    case Female = "female"
    
    case Unisex = "unisex"
}

class DataSource {
    
    public static var user: User?
    
    public static var itemCards: ItemCardStore?
    
    static func saveUser() {
        UserDefaults.standard.set(user?.toDictionary(), forKey: "CurrentUser")
        UserDefaults.standard.synchronize()
    }
    
    static func removeUser() {
        user = nil
        UserDefaults.standard.removeObject(forKey: "CurrentUser")
        UserDefaults.standard.synchronize()
    }
    
    static func checkUserInMemory() -> Bool {
        if let _ = UserDefaults.standard.value(forKey: "CurrentUser") as?  [String:Any] {
            return true
        } else {
            return false
        }
    }
    
    /*
        Try to use last user's email and password to authorize with it
     */
    static func loadUser(completion: @escaping (Bool, BadResponse?)->Void) {
        
        print(UserDefaults.standard.value(forKey: "CurrentUser"))
        
        if let json = UserDefaults.standard.value(forKey: "CurrentUser") as?  [String:Any]  {
            
            let email = json["email"] as! String
            let password = json["password"] as! String
            
            DataManager.authorize(email: email, password: password) { response in
                
                let temp = authUserHandler(response: response)
                completion(temp.0, temp.1)
            }
        }
    }
    
    /*
        Use given email and password to authorize with it
     */
    static func loadUser(email: String, password: String, completion: @escaping (Bool, BadResponse?)->Void) {
        
        DataManager.authorize(email: email, password: password) { response in
            
            let temp = authUserHandler(response: response)
            completion(temp.0, temp.1)
        }
        
    }
    
    /*
        Create seller user
     */
    static func createUser(email: String, password: String, name: String, completion: @escaping (Bool, BadResponse?)->Void) {
        
        DataManager.signUp(email: email, password: password, name: name) { response in
            
            let temp = authUserHandler(response: response)
            completion(temp.0, temp.1)
        }
    }
    
    /*
        Create customer user
     */
    static func createUser(email: String, password: String, name: String, gender: Gender, completion: @escaping (Bool, BadResponse?)->Void) {
        
        DataManager.signUp(email: email, password: password, name: name, gender: gender) { response in
            
            let temp = authUserHandler(response: response)
            completion(temp.0, temp.1)
        }
    }

    
    static func createUser(userType: UserType, email: String, password: String, completion: @escaping (Bool, BadResponse?)->Void) {
        
        DataManager.signUp(userType, email: email, password: password) { response in
            
            let temp = authUserHandler(response: response)
            completion(temp.0, temp.1)
        }
    }
    
    static func addItem(idToken: String, name: String, gender: ItemGender, category: ItemCategory, price: String, completion: @escaping (Bool) -> Void) {
        
        DataManager.addItem(idToken: idToken, name: name, gender: gender, category: category, price: price) { response in
            
            if let item = response as? Item {
                (user as! SellerUser).items.add(item: item)
                completion(true)
                return
            }
            
            completion(false)
        }
        
    }
    
    static func setLocation(idToken: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees, country: String, completion: @escaping (Bool) -> Void) {
        
        let la = "\(latitude)"
        let lo = "\(longitude)"
        
        DataManager.setLocation(idToken: idToken, latitude: la, longitude: lo, country: country) { response in
            
            if let loc = response as? Location {
                user?.location = loc
                completion(true)
                return
            }
            
            completion(false)
        }
    }
    
    class func getItems(idToken: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees, country: String, completion: @escaping (Bool) -> Void) {
        
        let la = "\(latitude)"
        let lo = "\(longitude)"
        
        DataManager.getItems(idToken: idToken, latitude: la, longitude: lo, country: country) { response in
            
            if let items = response as? ItemCardStore {
                itemCards = items
                completion(true)
                return
            }
            
            completion(false)
        }
    }
    
    private static func authUserHandler(response: CustomResponse) -> (Bool, BadResponse?) {
        
        if let user = response as? User {
            self.user = user
            saveUser()
            return (true, nil)
        }
        
        if let resp = response as? BadResponse {
            return (false, resp)
        }
        
        fatalError("Unexpected server response")
    }
    
    
}
