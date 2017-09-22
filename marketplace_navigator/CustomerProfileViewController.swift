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
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    @IBOutlet weak var profileNameLabel: UILabel!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var categoryTextField: UITextField!
    
    let imagePicker = UIImagePickerController()
    
    @IBAction func loadImageButtonTapped(_ sender: AnyObject) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
        
        imagePicker.delegate = self
        
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2
        self.profileImageView.clipsToBounds = true
        if let profImage = DataSource.user?.profileImage { profileImageView.image = profImage }
        
        profileNameLabel.text = DataSource.user?.name
    }
    
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
    
    
    @IBAction func paramTextField(_ sender: UITextField) {
        showChoiceMenu(title: "Choose category", items: ["All", "Shoes", "Underwear", "Denim", "Jackets", "Shirts", "Trousers"], todo: { item in
            sender.text = item
            DataSource.categoryToSearch = SearchItemCategory(rawValue: item.lowercased())!
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
    
    @IBAction func exitUser(_ sender: UIBarButtonItem) {
        DataSource.removeUser()
        
        let storyboard = UIStoryboard(name: "Authorization", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "entryVC")
        self.present(vc, animated: true)
    }
    
}
