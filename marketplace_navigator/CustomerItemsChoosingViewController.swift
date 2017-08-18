//
//  CustomerItemsChoosingViewController.swift
//  marketplace_navigator
//
//  Created by Александр Пономарев on 15.08.17.
//  Copyright © 2017 Base team. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class CustomerItemsChoosingViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestWhenInUseAuthorization()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        startLocationUpdate()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        locationManager.stopUpdatingLocation()
    }
    
    
    func startLocationUpdate() {
        
        let authorizationStatus = CLLocationManager.authorizationStatus()
        
        if authorizationStatus != .authorizedAlways {
            // Change UI
            
            return
        }
        
        if !CLLocationManager.locationServicesEnabled() {
            // The service is not available.
            
            // Change UI
            return
        }
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.distanceFilter = 500;
        
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let loc = locations.last!
        
        Location.getCountry(location: loc) { code, error in
            if (code == nil) {
                // Change UI
                return
            }
            
            DataSource.setLocation(idToken: DataSource.user!.idToken, latitude: loc.coordinate.latitude, longitude: loc.coordinate.longitude, country: code!) { success in
                
                //...
                print(DataSource.user?.location?.location)
                
                DataSource.getItems(idToken: DataSource.user!.idToken, latitude: loc.coordinate.latitude, longitude: loc.coordinate.longitude, country: code!) { success in

                    //...
                    for i in (DataSource.itemCards?.cards)! {
                        print(i.description)
                        print("\n")
                    }
                }
                
            }
        }
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
}
