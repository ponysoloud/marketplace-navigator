//
//  CustomerItemCell.swift
//  marketplace_navigator
//
//  Created by Александр Пономарев on 25.08.17.
//  Copyright © 2017 Base team. All rights reserved.
//

import Foundation
import UIKit

class CustomerItemCell: UITableViewCell {
    
    @IBOutlet weak var outerView: UIView!
    
    @IBOutlet var itemNameLabel: UILabel!
    
    @IBOutlet var itemImageView: UIImageView!
    
    @IBOutlet var brandNameLabel: UILabel!
    
    @IBOutlet weak var itemPriceLabel: UILabel!
    
    var item: Item!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        itemImageView.cornerRadius = 10.0
        outerView.cornerRadius = 10.0
    }
    
    func setValues(card: ItemCard) {
        self.item = card.item
        itemImageView.downloadedFrom(link: item.image)
        itemNameLabel.text = item.name
        itemPriceLabel.text = "\(item.price)$"
        brandNameLabel.text = card.hostName
    }
    
    
    
    
}
