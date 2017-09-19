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
            
            print("hide#1")
            
            return
        }
        
        if !CLLocationManager.locationServicesEnabled() {
            // Change UI
            errorTitleLabel.text = "Location services are currently unavailable"
            hideKolodaUI()
            
            print("hide#2")
            return
        }
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.distanceFilter = 500;
        //locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status != .authorizedAlways && status != .authorizedWhenInUse {
            // Change UI
            errorTitleLabel.text = "Has no acception to your location. Please accept it in \"Settings\""
            hideKolodaUI()
            
            print("hide#3")
        } else {
            // Change UI
            showKolodaUI()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        
        DataSource.getItems(idToken: DataSource.user!.idToken, location: locations.last!) { success in
            
            if success {
                if (self.kolodaView.dataSource == nil) {
                    self.kolodaView.dataSource = DataSource.itemCards!
                }
                
                let pos = self.kolodaView.currentCardIndex
                let newPos = DataSource.itemCards!.transfer()
                self.kolodaView.insertCardAtIndexRange(pos..<pos + newPos, animated: true)
                /*
                DataSource.itemCards!.transfer()
                self.kolodaView.reloadData()
                */
                
                if self.kolodaView.isRunOutOfCards {
                    self.errorTitleLabel.text = "Found nothing. Please change searching category or move to another location"
                    self.hideKolodaUI()
                } else {
                    self.showKolodaUI()
                }
                
                
            } else {
                // Change UI
                self.errorTitleLabel.text = "Connection problem. Please try again later"
                self.hideKolodaUI()
                
                print("hide#4")
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
        /*
        let pos = kolodaView.currentCardIndex
        let newPos = DataSource.itemCards!.transfer()
        kolodaView.insertCardAtIndexRange(pos..<pos + newPos, animated: true)
         */
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
