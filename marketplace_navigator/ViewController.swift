//
//  ViewController.swift
//  marketplace_navigator
//
//  Created by Александр Пономарев on 26.07.17.
//  Copyright © 2017 Base team. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    @IBOutlet weak var mailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var shopNameTextField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func signUpButton(_ sender: Any) {
        let url = "http://127.0.0.1:5000/auth"
        
        Alamofire.request(url, method: .post, parameters: ["email" : mailTextField.text!, "password" : passwordTextField.text!] , encoding: JSONEncoding.default).responseJSON { response in
            
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            
            if let json = response.result.value {
                print("JSON: \(json)") // serialized json response
            }

            
        }
        
    }

}

