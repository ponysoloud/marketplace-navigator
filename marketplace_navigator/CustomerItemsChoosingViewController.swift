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
import Koloda

class CustomerItemsChoosingViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var kolodaView: KolodaView!
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.kolodaView.delegate = self
        locationManager.requestWhenInUseAuthorization()
        defineLocationManager()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func defineLocationManager() {
        let authorizationStatus = CLLocationManager.authorizationStatus()
        
        if authorizationStatus != .authorizedAlways && authorizationStatus != .authorizedWhenInUse {
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
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status != .authorizedAlways && status != .authorizedWhenInUse {
            // Change UI
        } else {
            // Change UI
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        
        let loc = locations.last!
        DataSource.getItems(idToken: DataSource.user!.idToken, location: loc) { success, error in
            if success {
                if (self.kolodaView.dataSource == nil) { self.kolodaView.dataSource = DataSource.itemCards! }
            } else {
                // Change UI
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    @IBAction func leftButtonTapped() {
        kolodaView?.swipe(.left)
    }
    
    @IBAction func rightButtonTapped() {
        kolodaView?.swipe(.right)
    }
}

extension CustomerItemsChoosingViewController: KolodaViewDelegate {
    
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        locationManager.startUpdatingLocation()
        let pos = kolodaView.currentCardIndex
        let newPos = DataSource.itemCards!.transfer()
        kolodaView.insertCardAtIndexRange(pos..<pos + newPos, animated: true)
    }
    
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
        //...
    }
    
    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
        if direction == .right {
            let item = DataSource.itemCards![index]
            DataSource.likeItem(idToken: DataSource.user!.idToken, host: item.hostKey, shop: item.shopId, item: item.id) {
                if $0 { (DataSource.user as! CustomerUser).likedItems.add(item: item) }
            }
            
        }
    }
}
