//
//  UIViewControllerExtension.swift
//  marketplace_navigator
//
//  Created by Александр Пономарев on 22.09.17.
//  Copyright © 2017 Base team. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {

    func showHud() {
        LoadingHud.showAdded(to: self.view)
        
        view.isUserInteractionEnabled = false
    }
    
    func hideHUD() {
        LoadingHud.hide(at: self.view)
        view.isUserInteractionEnabled = true
    }
}
