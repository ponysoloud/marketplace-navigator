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
    
    @IBOutlet weak var kolodaControlButtons: UIView!
    
    @IBOutlet weak var errorTitleLabel: UILabel!
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.kolodaView.delegate = self
        locationManager.requestWhenInUseAuthorization()
        defineLocationManager()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locationManager.startUpdatingLocation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func hideKolodaUI() {
        kolodaView.isHidden = true
        errorTitleLabel.isHidden = false
    }
    
    func showKolodaUI() {
        kolodaView.isHidden = false
        errorTitleLabel.isHidden = true
    }
    
    func defineLocationManager() {
        let authorizationStatus = CLLocationManager.authorizationStatus()
        
        if authorizationStatus != .authorizedAlways && authorizationStatus != .authorizedWhenInUse {
            // Change UI
            errorTitleLabel.text = "Has no acception to your location. Please accept it in \"Settings\""
            hideKolodaUI()
            
            return
        }
        
        if !CLLocationManager.locationServicesEnabled() {
            // Change UI
            errorTitleLabel.text = "Location services are currently unavailable"
            hideKolodaUI()
            
            return
        }
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.distanceFilter = 500;
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("update")
        
        if status != .authorizedAlways && status != .authorizedWhenInUse {
            errorTitleLabel.text = "Has no acception to your location. Please accept it in \"Settings\""
            hideKolodaUI()
        } else {
            showKolodaUI()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        
        // Call HUD
        showHud()
        
        // Make request
        DataSource.getItems(idToken: DataSource.user!.idToken, location: locations.last!) { success in
            
            if success {
                
                if DataSource.categoryChangedFlag {
                    self.kolodaView.dataSource = DataSource.itemCards!
                    self.kolodaView.resetCurrentCardIndex()
                    
                    DataSource.categoryChangedFlag = false
                }
                
                // Hide HUD
                self.hideHUD()
                
                // Insert new cards
                let pos = self.kolodaView.currentCardIndex
                let newPos = DataSource.itemCards!.transfer()
                self.kolodaView.insertCardAtIndexRange(pos..<pos + newPos, animated: true)

                // Show message if all cards was fallen
                if self.kolodaView.isRunOutOfCards {
                    self.errorTitleLabel.text = "Found nothing. Please change searching category or move to another location"
                    self.hideKolodaUI()
                } else {
                    self.showKolodaUI()
                }
            } else {
                // Hide HUD
                self.hideHUD()
                
                self.errorTitleLabel.text = "Connection problem. Please try again later"
                self.hideKolodaUI()
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
