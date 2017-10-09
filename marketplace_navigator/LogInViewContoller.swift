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
    
    @IBOutlet weak var loadingImageView: UIImageView!
    
    @IBOutlet weak var mailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var logInButton: UIButton!
    
    @IBOutlet weak var topImageConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomImageConstraint: NSLayoutConstraint!
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
            topImageConstraint.constant = 40
        }
        
        if UIDevice.current.screenType == .iPhoneP {
            topImageConstraint.constant = 60
        }
        
        let loadingImages = (1...51).map { UIImage(named: "LogInLoadImg-\($0)")! }
        loadingImageView.animationImages = loadingImages
        loadingImageView.animationDuration = 1.0
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
        
        loadingImageView.startAnimating()
        
        DataSource.shared().loadUser(email: mailTextField.text!, password: passwordTextField.text!) { success, error in
            
            self.loadingImageView.stopAnimating()
            
            if success {
                
                var storyboardName: String = "CustomerInterface"
                
                if DataSource.shared().user is SellerUser {
                    storyboardName = "SellerInterface"
                }
                
                let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
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
    
    @objc func keyboardNotification(notification: NSNotification) {
        
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            if endFrame!.origin.y >= UIScreen.main.bounds.size.height {
                self.keyboardHeightLayoutConstraint?.constant = 70.0
                self.bottomImageConstraint?.constant = 50
            } else {
                self.keyboardHeightLayoutConstraint?.constant = endFrame?.size.height ?? 70.0
                self.bottomImageConstraint?.constant = 0
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
