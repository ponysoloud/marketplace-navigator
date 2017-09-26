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
    
    var shadow: Bool {
        get {
            return layer.shadowOpacity > 0.0
        }
        set {
            if newValue == true {
                self.addShadow()
            }
        }
    }
    
    func addShadow(shadowColor: CGColor = UIColor.black.cgColor,
                   shadowOffset: CGSize = CGSize(width: 0.0, height: -30.0),
                   shadowOpacity: Float = 0.04,
                   shadowRadius: CGFloat = 30.0) {
        layer.shadowColor = shadowColor
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
    }
    
    
    @discardableResult
    func fromNib<T : UIView>() -> T? {
        guard let view = Bundle.main.loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?[0] as? T else {
            return nil
        }
        
        //view.translatesAutoresizingMaskIntoConstraints = false
        view.frame = bounds
        self.addSubview(view)
        return view
    }
    
}
