//
//  CustomOverlayView.swift
//  marketplace_navigator
//
//  Created by Александр Пономарев on 19.08.17.
//  Copyright © 2017 Base team. All rights reserved.
//

import Foundation
import UIKit
import Koloda

private let overlayRightImageName = "LikeOverlay"
private let overlayLeftImageName = "DislikeOverlay"

class CustomOverlayView: OverlayView {
    
    @IBOutlet lazy var overlayImageView: UIImageView! = {
        [unowned self] in
        
        var imageView = UIImageView(frame: self.bounds)
        
        self.addSubview(imageView)
        
        return imageView
        }()
    
    override var overlayState: SwipeResultDirection? {
        didSet {
            switch overlayState {
            case .left? :
                overlayImageView.image = UIImage(named: overlayLeftImageName)
            case .right? :
                overlayImageView.image = UIImage(named: overlayRightImageName)
            default:
                overlayImageView.image = nil
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        overlayImageView.cornerRadius = 10.0
    }
    
    /*
    override init(frame: CGRect) {
        super.init(frame: frame)
        overlayImageView.cornerRadius = 10.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        overlayImageView.cornerRadius = 10.0
    }
 */
    
}
