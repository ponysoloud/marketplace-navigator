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

class DataSource {
    
    public static var user: User?
    
    public static var itemCards: ItemCardStore? {
        get {
            return itemCardsArray[categoryToSearch.hashValue]
        }
        
        set {
            itemCardsArray[categoryToSearch.hashValue] = newValue
        }
    }
    
    public static var categoryToSearch: SearchItemCategory = .All {
        didSet {
            categoryChangedFlag = true
        }
    }
    
    public static var categoryChangedFlag: Bool = true
    
    private static var itemCardsArray = [ItemCardStore?](repeating: nil, count: SearchItemCategory.count)
    
    static func saveUser() {
        UserDefaults.standard.set(user?.toDictionary(), forKey: "CurrentUser")
        UserDefaults.standard.synchronize()
    }
    
    static func removeUser() {
        user = nil
        UserDefaults.standard.removeObject(forKey: "CurrentUser")
        UserDefaults.standard.removeObject(forKey: "CurrentUserProfileImage")
        UserDefaults.standard.synchronize()
    }
    
    static func checkUserInMemory() -> Bool {
        return UserDefaults.standard.value(forKey: "CurrentUser") is  [String:Any]
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
    
    static func addItem(idToken: String, shopId: String, itemId: String, name: String, gender: ItemGender, category: ItemCategory, price: String, completion: @escaping (Bool) -> Void) {
        
        DataManager.addItem(idToken: idToken, shopId: shopId, itemId: itemId, name: name, gender: gender, category: category, price: price) { response in
            
            if let item = response as? Item {
                (user as! SellerUser).shops.get(with: shopId)!.items.add(item: item)
                completion(true)
                return
            }
            
            completion(false)
        }
        
    }
    
    static func setLocation(idToken: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees, completion: @escaping (Bool) -> Void) {
        
        let la = "\(latitude)"
        let lo = "\(longitude)"
        
        DataManager.setLocation(idToken: idToken, latitude: la, longitude: lo) { response in
            
            if let loc = response as? Location {
                (user as? CustomerUser)?.location = loc
                completion(true)
                return
            }
            
            completion(false)
        }
    }
    
    class func getItems(idToken: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees, completion: @escaping (Bool) -> Void) {
        
        let la = "\(latitude)"
        let lo = "\(longitude)"
        
        DataManager.getItems(idToken: idToken, latitude: la, longitude: lo, category: categoryToSearch, gender: (user as! CustomerUser).gender) { response in
            
            if let items = response as? ItemCardStore {
                if itemCards == nil {
                    itemCards = items
                } else {
                    itemCards?.append(store: items)
                }
                completion(true)
                return
            }
            
            completion(false)
        }
    }
    
    class func getItems(idToken: String, location: CLLocation, completion: @escaping (Bool) -> Void) {
        
        let la = location.coordinate.latitude
        let lo = location.coordinate.longitude
        
        self.setLocation(idToken: idToken, latitude: la, longitude: lo) {
            
            if $0 {
                self.getItems(idToken: idToken, latitude: la, longitude: lo) {
                    completion($0)
                }
            } else {
                completion(false)
            }
        }
        
    }
    
    /*
    class func getItems(idToken: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees, country: String, completion: @escaping (Bool) -> Void) {
        
        let la = "\(latitude)"
        let lo = "\(longitude)"
        
        DataManager.getItems(idToken: idToken, latitude: la, longitude: lo, country: country) { response in
            
            if let items = response as? ItemCardStore {
                if itemCards == nil {
                    itemCards = items
                } else {
                    itemCards?.append(store: items)
                }
                completion(true)
                return
            }
            
            completion(false)
        }
    }
    
    class func getItems(idToken: String, location: CLLocation, completion: @escaping (Bool, BadResponse?) -> Void) {
        
        Location.getCountry(location: location) { code, error in
            if (code == nil) {
                let bad = BadResponse(target: .Country, message: error!.localizedDescription)
                completion(false, bad)
                
                return
            }
            
            let la = location.coordinate.latitude
            let lo = location.coordinate.longitude
            
            self.setLocation(idToken: idToken, latitude: la, longitude: lo, country: code!) { success in
                
                if success {
                    self.getItems(idToken: idToken, latitude: la, longitude: lo, country: code!) { success in
                        
                        if success {
                            completion(true, nil)
                        }
                        
                        completion(false, nil)
                        return
                    }
                }
                
                completion(false, nil)
                return
            }
        }

    }
    */
    
    class func likeItem(idToken: String, host: String, shop: String, item: String, completion: @escaping (Bool) -> Void) {
        
        DataManager.likeItem(idToken: idToken, host: host, shop: shop, item: item) { response in
            
            if let _ = response as? GoodResponse {
                completion(true)
                return
            }
            
            completion(false)
        }
        
    }
    
    class func dislikeItem(idToken: String, item: String, completion: @escaping (Bool) -> Void) {
        
        DataManager.dislikeItem(idToken: idToken, item: item) { response in
            
            if let _ = response as? GoodResponse {
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
