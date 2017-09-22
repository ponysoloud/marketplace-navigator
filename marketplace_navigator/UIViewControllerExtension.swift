//
//  UIViewControllerExtension.swift
//  marketplace_navigator
//
//  Created by Александр Пономарев on 22.09.17.
//  Copyright © 2017 Base team. All rights reserved.
//

import Foundation
import MBProgressHUD

extension UIViewController {
    
    func showHud(_ message: String) {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.label.text = message
        hud.isUserInteractionEnabled = false
    }
    
    func hideHUD() {
        MBProgressHUD.hide(for: self.view, animated: true)
    }
}
