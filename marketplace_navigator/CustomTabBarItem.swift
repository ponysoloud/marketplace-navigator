//
//  CustomTabBarItem.swift
//  marketplace_navigator
//
//  Created by Александр Пономарев on 22.09.17.
//  Copyright © 2017 Base team. All rights reserved.
//

import UIKit

class CustomTabBarItem: UIView {
    
    var iconView: UIImageView!
    
    override init (frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init () {
        self.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Create custom tab bar item according to default item
    func setup(item: UITabBarItem) {
        
        let image: UIImage!
        
        if let img = item.image {
            image = img
        } else {
            fatalError("add images to tabbar items")
        }
        
        // create imageView centered within a container
        iconView = UIImageView(frame: CGRect(x: (self.frame.width-image.size.width)/2, y: (self.frame.height-image.size.height)/2, width: self.frame.width, height: self.frame.height))
        
        iconView.image = image
        iconView.sizeToFit()
        
        self.addSubview(iconView)
    }
    
    
    
}
