//
//  DataSource.swift
//  marketplace_navigator
//
//  Created by Александр Пономарев on 02.08.17.
//  Copyright © 2017 Base team. All rights reserved.
//

import Foundation
import CoreLocation

class DataSource {
    
    var user: User?
    
    var itemCards: ItemCardStore? {
        get { return itemCardsArray[categoryToSearch.hashValue] }
        
        set { itemCardsArray[categoryToSearch.hashValue] = newValue }
    }
    
    var categoryToSearch: SearchItemCategory = .All {
        didSet {
            categoryChangedFlag = true
        }
    }
    
    var categoryChangedFlag: Bool = true
    
    private var itemCardsArray = [ItemCardStore?](repeating: nil, count: SearchItemCategory.count)
    
}

extension DataSource {
    
    private static var instance: DataSource?
    
    class func shared() -> DataSource {
        guard let insta = instance else {
            instance = DataSource()
            return instance!
        }
        
        return insta
    }
    
    class func reset() {
        instance = nil
    }
}

extension DataSource: DataSourceControls {
    
    func checkMemory() -> Bool {
        return UserDefaults.standard.value(forKey: "CurrentUser") is [String: Any]
    }
    
    func saveInMemory() {
        UserDefaults.standard.set(user?.toDictionary(), forKey: "CurrentUser")
        UserDefaults.standard.synchronize()
    }
    
    func removeFromMemory() {
        
        UserDefaults.standard.removeObject(forKey: "CurrentUser")
        UserDefaults.standard.removeObject(forKey: "CurrentUserProfileImage")
        UserDefaults.standard.synchronize()
    }
    
    func loadUser(completion: @escaping (Bool, BadResponse?)->Void) {
        
        guard let json = UserDefaults.standard.value(forKey: "CurrentUser") as?  [String: Any] else {
            let error = BadResponse(target: .None, message: "Invalid json")
            completion(false, error)
            return
        }
        
        let email = json["email"] as! String
        let password = json["password"] as! String
        
        DataManager.authorize(email: email, password: password) { response in
            
            let temp = self.handleAuthorization(response: response)
            completion(temp.0, temp.1)
        }
    }
    
    func loadUser(email: String, password: String, completion: @escaping (Bool, BadResponse?)->Void) {
        
        DataManager.authorize(email: email, password: password) { response in
            
            let temp = self.handleAuthorization(response: response)
            completion(temp.0, temp.1)
        }
    }
    
    func createUser(email: String, password: String, name: String, gender: Gender, completion: @escaping (Bool, BadResponse?)->Void) {
        
        DataManager.signUp(email: email, password: password, name: name, gender: gender) { response in
            
            let temp = self.handleAuthorization(response: response)
            completion(temp.0, temp.1)
        }
    }
    
    private func handleAuthorization(response: CustomResponse) -> (Bool, BadResponse?) {
        
        if let user = response as? User {
            self.user = user
            saveInMemory()
            return (true, nil)
        }
        
        if let resp = response as? BadResponse {
            return (false, resp)
        }
        
        fatalError("Unexpected server response")
    }
    
    func getItems(by location: CLLocation, completion: @escaping (Bool) -> Void) {
        
        let la = location.coordinate.latitude
        let lo = location.coordinate.longitude
        
        self.setLocation(latitude: la, longitude: lo) {
            if $0 {
                self.getItems(latitude: la, longitude: lo) { completion($0) }
            } else {
                completion($0)
            }
        }
    }
    
    private func setLocation(latitude: CLLocationDegrees, longitude: CLLocationDegrees, completion: @escaping (Bool) -> Void) {
        
        let la = "\(latitude)"
        let lo = "\(longitude)"
        
        guard let token = user?.idToken else { fatalError("No user in system") }
        
        DataManager.setLocation(idToken: token, latitude: la, longitude: lo) { response in
            
            if let loc = response as? Location {
                (self.user as? CustomerUser)?.location = loc
                completion(true)
                return
            }
            
            completion(false)
        }
    }
    
    private func getItems(latitude: CLLocationDegrees, longitude: CLLocationDegrees, completion: @escaping (Bool) -> Void) {
        
        let la = "\(latitude)"
        let lo = "\(longitude)"
        
        guard let token = user?.idToken else { fatalError("No user in system") }
        
        DataManager.getItems(idToken: token, latitude: la, longitude: lo, category: categoryToSearch, gender: (user as! CustomerUser).gender) { response in
            
            if let items = response as? ItemCardStore {
                if self.itemCards == nil {
                    self.itemCards = items
                } else {
                    self.itemCards?.append(store: items)
                }
                completion(true)
                return
            }
            
            completion(false)
        }
    }
    
    func likeItem(host: String, shop: String, item: String, completion: @escaping (Bool) -> Void) {
        
        guard let token = user?.idToken else { fatalError("No user in system") }
        
        DataManager.likeItem(idToken: token, host: host, shop: shop, item: item) { response in
            
            completion(response is GoodResponse)
            return
        }
    }
    
    func removeLiked(item: String, completion: @escaping (Bool) -> Void) {
        
        guard let token = user?.idToken else { fatalError("No user in system") }
        
        DataManager.dislikeItem(idToken: token, item: item) { response in
            
            completion(response is GoodResponse)
            return
        }
    }
}




