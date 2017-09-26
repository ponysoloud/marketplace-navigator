//
//  AnimationView.swift
//  marketplace_navigator
//
//  Created by Александр Пономарев on 26.09.17.
//  Copyright © 2017 Base team. All rights reserved.
//

import Foundation
import UIKit

class AnimationView: UIView {
    
    public final func startAnimating() {
        isHidden = false
        layer.speed = 1
        setUpAnimation()
    }
    
    public final func stopAnimating() {
        isHidden = true
        layer.sublayers?.removeAll()
    }
    
    private final func setUpAnimation() {
        let animation = BallClipAnimation()
        var animationRect = UIEdgeInsetsInsetRect(frame, UIEdgeInsetsMake(15, 15, 15, 15))
        let minEdge = min(animationRect.width, animationRect.height)
        let color = UIColor(red:0.22, green:0.71, blue:0.88, alpha:1.00)
        
        layer.sublayers = nil
        animationRect.size = CGSize(width: minEdge, height: minEdge)
        animation.setUpAnimation(in: layer, size: animationRect.size, color: color)
    }
}
