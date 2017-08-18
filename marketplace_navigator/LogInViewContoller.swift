//
//  LogInViewContoller.swift
//  marketplace_navigator
//
//  Created by Александр Пономарев on 02.08.17.
//  Copyright © 2017 Base team. All rights reserved.
//

import Foundation
import UIKit

class LogInViewContoller: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var mailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var mailTextView: UITextView!
    
    @IBOutlet weak var passwordTextView: UITextView!
    
    @IBOutlet weak var logInButton: UIButton!
    
    @IBOutlet var keyboardHeightLayoutConstraint: NSLayoutConstraint?
    
    @IBOutlet weak var imageSizeLayoutConstraint: NSLayoutConstraint!
    
    var flags = Array(repeating: false, count: 2) {
        didSet {
            logInButton.isEnabled = !flags.contains(false)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UIDevice.current.screenType == .iPhone5_5c_5s {
            imageSizeLayoutConstraint.constant = 0
        }
        
        if UIDevice.current.screenType == .iPhoneP {
            imageSizeLayoutConstraint.constant = 80
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func logIn(_ sender: Any) {
        
        DataSource.loadUser(email: mailTextField.text!, password: passwordTextField.text!) { success, error in
            
            if success {
                print(success)
                
                var storyboardName: String = "CustomerInterface"
                
                if let _ = DataSource.user as? SellerUser {
                    storyboardName = "SellerInterface"
                }
                
                let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "entryVC")
                self.navigationController?.pushViewController(vc, animated: true)
                
            } else {
                if let errorInfo = error?.getInfo() {
                    switch errorInfo.0 {
                        
                    case .Email:
                        self.mailTextView.text = errorInfo.1
                        
                    case .Password:
                        self.passwordTextView.text = errorInfo.1
                        
                    }
                }
            }
        }
    }
    
    @objc func keyboardNotification(notification: NSNotification) {
        
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            if (endFrame?.origin.y)! >= UIScreen.main.bounds.size.height {
                self.keyboardHeightLayoutConstraint?.constant = 70.0
            } else {
                self.keyboardHeightLayoutConstraint?.constant = endFrame?.size.height ?? 70.0
            }
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var flag: Bool = true
        
        if string.isEmpty {
            if textField.text!.characters.count <= 1 {
                flag = false
            }
        }
        
        flags[textField.tag] = flag
        
        print("Change to \(flags[textField.tag])")
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        
        return false
    }
    
    @IBAction func dismissKeyboard(_ sender: AnyObject) {
        self.view.endEditing(true)
    }
    
}
