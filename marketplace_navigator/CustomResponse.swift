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
    
    case Country
    
    case None
    
}

class CustomResponse: NSObject{
    
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
    private var target: BadResponseTarget = .None
    
    init(target: BadResponseTarget, message: String) {
        self.target = target
        self.message = message
    }
    
    init(json: [String : Any]) {
        
        print(json)
        
        if let code = json["code"] as? String {
            self.code = code
        }
        
        if let error = json["error"] as? [String : Any] {
        
            if let message = error["message"] as? String {
                self.message = message
                
                if self.message.contains("EMAIL") {
                    target = .Email
                    self.message = "Sorry, we can't find an account with this email address."
                }
                
                if self.message.contains("PASSWORD") {
                    target = .Password
                    self.message = "Entered password is invalid"
                }
                
            }
        }
    }
    
    func getInfo() -> (BadResponseTarget, String) {
        
        return(target, message)
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
                let cardStore = ItemCardStore(json: info)
                    cardStore.transfer()
                return cardStore
            }
        }
        
        if rType == "empty" {
            return GoodResponse()
        }
        
        fatalError("Invalid json response")
    }
    
}
