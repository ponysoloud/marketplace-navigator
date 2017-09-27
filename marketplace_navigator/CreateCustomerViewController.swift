//
//  CreateCustomerViewController.swift
//  marketplace_navigator
//
//  Created by Александр Пономарев on 04.08.17.
//  Copyright © 2017 Base team. All rights reserved.
//

import Foundation
import UIKit

class CreateCustomerViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var mailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var genderTextField: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        self.navigationController?.navigationBar.topItem?.title = "Customer"
        
        self.navigationController?.navigationBar.backItem?.title = ""
        
        mailTextField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @IBAction func signUpButton(_ sender: Any) {
        
        showHud()
        
        let tempRaw = genderTextField.text!.lowercased()
        let gender = Gender(rawValue: tempRaw)
        
        DataSource.createUser(email: mailTextField.text!, password: passwordTextField.text!, name: nameTextField.text!, gender: gender!) {
            success, error in
            
            self.hideHUD()
            
            if success {
                
                let storyboard = UIStoryboard(name: "CustomerInterface", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "entryVC")
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
            if let errorInfo = error?.getInfo() {
                
                let alert = UIAlertController(title: "Error", message: errorInfo.1, preferredStyle: UIAlertControllerStyle.alert)
                
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
            }
            
        }
        
    }
    
    @IBAction func genderTextFieldTap(_ sender: Any) {
        
        showChoiceMenu(title: "Choose gender", items: ["Male", "Female"], todo: { item in
            self.genderTextField.text = item
        })
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        
        return false
    }
    
    @IBAction func dismissKeyboard(_ sender: AnyObject) {
        self.view.endEditing(true)
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
