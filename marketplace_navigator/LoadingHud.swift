//
//  LoadingHud.swift
//  marketplace_navigator
//
//  Created by Александр Пономарев on 26.09.17.
//  Copyright © 2017 Base team. All rights reserved.
//

import UIKit

class LoadingHud {
    
    class func showAdded(to view: UIView) {
        let hud = AnimationView(frame: CGRect(x: 0, y: 0, width: 70, height: 70))
            hud.center = view.center
            hud.center.y -= 50
            hud.cornerRadius = 10.0
            hud.backgroundColor = UIColor.white
            hud.tag = 100
        
            hud.startAnimating()
        
        view.addSubview(hud)
    }
    
    class func hide(at view: UIView) {
        if let hud = view.viewWithTag(100) as? AnimationView {
            hud.stopAnimating()
            hud.removeFromSuperview()
        }
    }
    
}
