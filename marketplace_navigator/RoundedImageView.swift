//
//  RoundedImageView.swift
//  marketplace_navigator
//
//  Created by Александр Пономарев on 23.09.17.
//  Copyright © 2017 Base team. All rights reserved.
//

import Foundation
import UIKit

class RoundedImageView: UIImageView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let radius = self.frame.width / 2
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    
}
