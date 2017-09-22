//
//  CardView.swift
//  marketplace_navigator
//
//  Created by Александр Пономарев on 19.08.17.
//  Copyright © 2017 Base team. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
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

class CardView: UIView {
    
    @IBOutlet weak var itemName: UILabel!
    
    @IBOutlet weak var itemCost: UILabel!
    
    @IBOutlet weak var brandName: UILabel!
    
    @IBOutlet weak var itemImage: UIImageView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fromNib()
    }
    
    init(card: ItemCard) {
        super.init(frame: CGRect())
        layer.cornerRadius = 10
        layer.masksToBounds = true
        fromNib()
        itemImage.downloadedFrom(link: card.item.image)
        itemName.text = card.item.name
        itemCost.text = "\(card.item.price)$"
        brandName.text = card.hostName
    }
    
    
    
}
