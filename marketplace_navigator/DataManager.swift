//
//  DataManager.swift
//  marketplace_navigator
//
//  Created by Александр Пономарев on 28.07.17.
//  Copyright © 2017 Base team. All rights reserved.
//

import Foundation
import Alamofire

class DataManager {
    
    private class func request(url:String, method: HTTPMethod, parameters: Parameters?, completion: @escaping (Dictionary<String,Any>) -> Void){
        
        let urlAll = "http://127.0.0.1:5000/" + url
        
        Alamofire.request(urlAll, method: method, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            //debugPrint(response)
            
            if let result = response.result.value {
                let JSON = result as? Dictionary<String, Any>
                completion(JSON ?? [String:Any]())
            }
        }
    }
    
    class func authorize(email: String, password: String, completion: @escaping (CustomResponse) -> Void) {
        DataManager.request(url: "auth", method: .post, parameters: ["email":email, "password":password]) {
            json in
            
            let response = CustomResponse.create(params: ["email":email, "password":password], json: json)
            completion(response)
        }
    }
    
    class func signUp(email: String, password: String, name: String, completion: @escaping (CustomResponse) -> Void) {
        
        DataManager.request(url: "signup/seller", method: .post, parameters: ["email":email, "password":password, "name": name]) {
            json in
            
            let response = CustomResponse.create(params: ["email":email, "password":password], json: json)
            completion(response)
        }
    }
    
    class func signUp(email: String, password: String, name: String, gender: Gender, completion: @escaping (CustomResponse) -> Void) {
        
        DataManager.request(url: "signup/customer", method: .post, parameters: ["email":email, "password":password, "name": name, "gender": gender.rawValue]) {
            json in
            
            let response = CustomResponse.create(params: ["email":email, "password":password] , json: json)
            completion(response)
        }
    }

    class func signUp(_ userType: UserType, email: String, password: String, completion: @escaping (CustomResponse) -> Void) {
        DataManager.request(url: "signup/"+userType.rawValue, method: .post, parameters: ["email":email, "password":password]) {
            json in
            
            let response = CustomResponse.create(params: ["email":email, "password":password], json: json)
            completion(response)
        }
    }
    
    class func addItem(idToken: String, shopId: String, itemId: String, name: String, gender: ItemGender, category: ItemCategory, price: String, completion: @escaping (CustomResponse) -> Void) {
        DataManager.request(url: "additem", method: .post, parameters: ["idToken": idToken, "shopId": shopId, "itemId": itemId, "name": name, "gender": gender.rawValue, "category": category.rawValue , "price": price]) {
            json in
            
            let response = CustomResponse.create(params: [:], json: json)
            completion(response)
        }
        
    }
    
    class func setLocation(idToken: String, latitude: String, longitude: String, completion: @escaping (CustomResponse) -> Void) {
        DataManager.request(url: "setlocation", method: .post, parameters: ["idToken": idToken, "latitude": latitude, "longitude": longitude]) {
            json in
            
            let response = CustomResponse.create(params: [:], json: json)
            completion(response)
        }
    }
    
    class func getItems(idToken: String, latitude: String, longitude: String, category: SearchItemCategory, completion: @escaping (CustomResponse) -> Void) {
        DataManager.request(url: "getitems", method: .post, parameters: ["idToken": idToken, "latitude": latitude, "longitude": longitude, "category": category.rawValue]) { json in
            
            let response = CustomResponse.create(params: [:], json: json)
            completion(response)
        }
    }
    
    class func likeItem(idToken: String, host: String, shop: String, item: String, completion: @escaping (CustomResponse) -> Void) {
        DataManager.request(url: "likeitem", method: .post, parameters: ["idToken": idToken, "hostId": host, "shopId": shop, "itemId": item]) { json in
            
            let response = CustomResponse.create(params: [:], json: json)
            completion(response)
        }
    }
    
    
}
