//
//  LaunchViewController.swift
//  marketplace_navigator
//
//  Created by Александр Пономарев on 08.08.17.
//  Copyright © 2017 Base team. All rights reserved.
//

import Foundation
import UIKit

class LaunchViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if DataSource.checkUserInMemory() {
            DataSource.loadUser { success, error in
                
                var storyboardName: String = "Authorization"
                
                if success {
                    print(success)
                    
                    if let _ = DataSource.user as? SellerUser {
                        storyboardName = "SellerInterface"
                    } else {
                        storyboardName = "CustomerInterface"
                    }
                    
                }
                
                let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "entryVC")
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    
}
