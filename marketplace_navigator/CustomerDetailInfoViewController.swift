//
//  CustomerDetailInfoViewController.swift
//  marketplace_navigator
//
//  Created by Александр Пономарев on 21.09.17.
//  Copyright © 2017 Base team. All rights reserved.
//

import Foundation
import UIKit

class CustomerDetailInfoViewController: UIViewController {
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var infoView: UIView!
    
    @IBOutlet weak var itemImageView: UIImageView!
    
    @IBOutlet weak var itemName: UILabel!
    
    @IBOutlet weak var hostName: UILabel!
    
    @IBOutlet weak var shopName: UILabel!
    
    @IBOutlet weak var category: UILabel!
    
    @IBOutlet weak var sex: UILabel!
    
    @IBOutlet weak var price: UILabel!
    
    var itemId: String?
    
    var itemIndexPathOnTableView: IndexPath?
    
    var parentTableViewController: CustomerUserGoodsTableViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        
        let insets = UIEdgeInsetsMake(-statusBarHeight, 0, 0, 0)
        scrollView.contentInset = insets
        
        infoView.cornerRadius = 10.0
        infoView.shadow = true
        
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
    }
    
    
    func setValues(with card: ItemCard) {
        itemImageView.downloadedFrom(link: card.item.image)
        itemName.text = card.item.name
        category.text = card.item.category.rawValue.capitalizingFirstLetter()
        sex.text = card.item.gender.rawValue.capitalizingFirstLetter()
        price.text = "\(card.item.price)$"
        hostName.text = card.hostName
        shopName.text = card.shopName
        
        itemId = card.id
    }
    
    @IBAction func removeItem(_ sender: UIButton) {
        showHud()
        sender.isUserInteractionEnabled = false
        
        DataSource.dislikeItem(idToken: DataSource.user!.idToken, item: itemId!) {
            if $0 {
                
                self.hideHUD()
                sender.isUserInteractionEnabled = false
                
                self.parentTableViewController?.removeItem(at: self.itemIndexPathOnTableView!)
                self.dismissCurrentVC(sender)
            }
        }
    }
    
    @IBAction func dismissCurrentVC(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
