//
//  CustomerProfileViewController.swift
//  marketplace_navigator
//
//  Created by Александр Пономарев on 07.09.17.
//  Copyright © 2017 Base team. All rights reserved.
//

import Foundation
import UIKit

class CustomerProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var profileNameLabel: UILabel!
    
    @IBOutlet weak var genderLabel: UILabel!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    @IBAction func loadImageButtonTapped(_ sender: AnyObject) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2
        self.profileImageView.clipsToBounds = true
        
        if let profImage = DataSource.user?.profileImage {
            profileImageView.image = profImage
        }
        genderLabel.text = (DataSource.user as! CustomerUser).gender.rawValue
        genderLabel.text?.capitalizeFirstLetter()
        profileNameLabel.text = DataSource.user?.name
    }
    
    
    // MARK: - UIImagePickerControllerDelegate Methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            profileImageView.image = pickedImage
            DataSource.user?.profileImage = pickedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
