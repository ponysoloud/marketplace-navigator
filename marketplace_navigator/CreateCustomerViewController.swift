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
        
        let tempRaw = genderTextField.text!.lowercased()
        let gender = Gender(rawValue: tempRaw)
        
        DataSource.createUser(email: mailTextField.text!, password: passwordTextField.text!, name: nameTextField.text!, gender: gender!) {
            success, error in
            
            if success {
                print(success)
            }
            
        }
        
    }
    
    @IBAction func genderTextFieldTap(_ sender: Any) {
        
        print("tap")
        
        let genderMenu = UIAlertController(title: nil, message: "Choose gender", preferredStyle: .actionSheet)
        
        let setGenderWithMale = UIAlertAction(title: "Male", style: .default) {
            (result : UIAlertAction) -> Void in
            
            self.genderTextField.text = "Male"
            
        }
        
        let setGenderWithFemale = UIAlertAction(title: "Female", style: .default) {
            (result : UIAlertAction) -> Void in
            
            self.genderTextField.text = "Female"
            
        }
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {
            (result : UIAlertAction) -> Void in
            
        }
        
        genderMenu.addAction(setGenderWithMale)
        genderMenu.addAction(setGenderWithFemale)
        genderMenu.addAction(cancelAction)
        self.present(genderMenu, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        
        return false
    }
    
    @IBAction func dismissKeyboard(_ sender: AnyObject) {
        self.view.endEditing(true)
    }
    
}
