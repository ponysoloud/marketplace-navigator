//
//  SellerAddGoodViewController.swift
//  marketplace_navigator
//
//  Created by Александр Пономарев on 09.08.17.
//  Copyright © 2017 Base team. All rights reserved.
//

import Foundation
import UIKit

class SellerAddGoodViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var categoryTextField: UITextField!
    
    @IBOutlet weak var genderTextField: UITextField!
    
    @IBOutlet weak var priceTextField: UITextField!
    
    @IBOutlet weak var addButton: UIButton!
    
    var currentChoiceMenu: UIAlertController?
    
    var flags = Array(repeating: false, count: 4) { didSet { addButton.isEnabled = !flags.contains(false) } }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var flag: Bool = true
        
        if string.isEmpty {
            if textField.text!.characters.count <= 1 {
                flag = false
            }
        }
        
        flags[textField.tag] = flag
        
        return true
    }
    
    
    @IBAction func addButtonTap(_ sender: Any) {
        let tempRaw = genderTextField.text!.lowercased()
        let gender = ItemGender(rawValue: tempRaw)
        
        let tempRaw1 = categoryTextField.text!.lowercased()
        let category = ItemCategory(rawValue: tempRaw1)
        
        
        DataSource.addItem(idToken: DataSource.user!.idToken, name: nameTextField.text!, gender: gender!, category: category!, price: priceTextField.text!) { success in
            
            if success {
                self.dismissCurrentVC(sender)
            }
        }
    }
    
    
    @IBAction func dismissCurrentVC(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func dismissChoiceMenu() {
        currentChoiceMenu?.dismiss(animated: true, completion: { self.currentChoiceMenu = nil })
    }
    
    @IBAction func genderTextFieldTap(_ sender: Any) {
        
        currentChoiceMenu = showChoiceMenu(title: "Choose gender", items: ["Male", "Female", "Unisex"], todo: { item in
            self.genderTextField.text = item
            self.flags[2] = true
        })
    }
    
    @IBAction func categoryTextFieldTap(_ sender: Any) {
        
        currentChoiceMenu = showChoiceMenu(title: "Choose category", items: ["Shoes", "Underwear"], todo: { item in
            self.categoryTextField.text = item
            self.flags[1] = true
        })
    }
    
    @discardableResult func showChoiceMenu(title: String, items: [String], todo: @escaping (String) -> Void) -> UIAlertController {
        
        let menu = UIAlertController(title: nil, message: title, preferredStyle: .actionSheet)
        
        for i in items {
            let action = UIAlertAction(title: i, style: .default, handler: { _ in todo(i) })
            menu.addAction(action)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {
            (result : UIAlertAction) -> Void in
        }
        menu.addAction(cancelAction)
        
        self.present(menu, animated: true, completion: nil)
        return menu
    }
    
}
