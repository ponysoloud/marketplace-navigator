//
//  SellerProfileViewController.swift
//  marketplace_navigator
//
//  Created by Александр Пономарев on 02.08.17.
//  Copyright © 2017 Base team. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class SellerProfileViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var status: UILabel!
    
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self;
        locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        name.text = DataSource.user?.name
    }
    
    @IBAction func setPosition(_ sender: Any) {
        
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse: break
        case .authorizedAlways: break
        default:
            locationManager.requestWhenInUseAuthorization()
        }
        
        locationManager.requestLocation()
    }
    
    
    
}
