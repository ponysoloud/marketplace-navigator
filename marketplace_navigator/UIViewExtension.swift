//
//  UIViewExtension.swift
//  marketplace_navigator
//
//  Created by Александр Пономарев on 18.09.17.
//  Copyright © 2017 Base team. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        
        set {
            self.layer.cornerRadius = newValue
        }
    }
    
}
