//
//  Location.swift
//  marketplace_navigator
//
//  Created by Александр Пономарев on 15.08.17.
//  Copyright © 2017 Base team. All rights reserved.
//

import Foundation
import CoreLocation

class Location: GoodResponse {
    
    var location: CLLocation
    
    init(_ json: [String: Any]) {
        
        if  let lacoord = json["latitude"] as? String, let locoord = json["longitude"] as? String, let la = Double(lacoord), let lo = Double(locoord) {
                location = CLLocation(latitude: la, longitude: lo)
        } else {
            location = CLLocation(latitude: 51.509865, longitude: -0.118092)
        }
    }
    
}
