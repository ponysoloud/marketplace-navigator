//
//  CustomResponse.swift
//  marketplace_navigator
//
//  Created by Александр Пономарев on 02.08.17.
//  Copyright © 2017 Base team. All rights reserved.
//

import Foundation


enum BadResponseTarget: Int {
    
    case Email
    
    case Password
    
}

class CustomResponse {
    
    class func create(params: [String: Any], json: [String : Any]) -> CustomResponse {
        
        guard let _ = json["error"] as? [String: Any] else {
            return GoodResponse.create(params: params, json: json)
        }
        
        return BadResponse(json: json)
    }
    
}

class BadResponse: CustomResponse {
    
    private var message: String = ""
    private var code: String = ""
    
    init(json: [String : Any]) {
        
        print(json)
        
        if let code = json["code"] as? String {
            self.code = code
        }
        
        if let error = json["error"] as? [String : Any] {
        
            if let message = error["message"] as? String {
                self.message = message
            }
        }
    }
    
    func getInfo() -> (BadResponseTarget, String) {
        
        if message.contains("EMAIL") {
            return (.Email, message)
        }
        
        if message.contains("PASSWORD") {
            return (.Password, message)
        }
        
        //ЗАГЛУШКА
        fatalError("Заглушка")
    }
    
}

class GoodResponse: CustomResponse {
    
    override class func create(params: [String: Any], json: [String: Any]) -> GoodResponse {
        
        print(json)
        
        guard let rType = json["infoType"] as? String  else {
            fatalError("Invalid json response")
        }
        
        if rType == "user" {
            if let info = json["info"] as? [String: Any] {
                return User.create(params: params, json: info)
            }
        }
        
        if rType == "item" {
            if let info = json["info"] as? [String: Any] {
                return Item(json: info)
            }
            
        }
        
        if rType == "location" {
            if let info = json["info"] as? [String: Any] {
                return Location(info)
            }
        }
        
        if rType == "searching" {
            if let info = json["info"] as? [String: Any] {
                return ItemCardStore(json: info)
            }
        }
        
        if rType == "empty" {
            return GoodResponse()
        }
        
        fatalError("Invalid json response")
    }
    
}
