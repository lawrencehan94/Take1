//
//  SignupVC.swift
//  Tumblr
//
//  Created by Lawrence Han on 9/28/17.
//  Copyright © 2017 Lawrence Han. All rights reserved.
//

import UIKit
import Firebase

class SignupVC: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var addPhotoButton: UIButton!
    
    @IBAction func signupButtonPressed(_ sender: UIButton) {
        signupUser()
    }
    
    @IBAction func addPhotoButtonPressed(_ sender: UIButton) {
        presentImagePicker()
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        let loginSB = UIStoryboard(name: "Login", bundle: nil)
        let loginVC = loginSB.instantiateViewController(withIdentifier: "LoginVC")
        present(loginVC, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailField.addTarget(self, action: #selector(makeSignupButtonGreen), for: .editingChanged)
        usernameField.addTarget(self, action: #selector(makeSignupButtonGreen), for: .editingChanged)
        passwordField.addTarget(self, action: #selector(makeSignupButtonGreen), for: .editingChanged)
        signupButton.isEnabled = false
        
    }

    func signupUser() {
        guard let email = emailField.text, email.characters.count > 0 else { return }
        guard let username = usernameField.text, username.characters.count > 0 else { return }
        guard let password = passwordField.text, password.characters.count > 0 else { return }
        
        // STEP 1: CREATE USER WITH EMAIL AND PASSWORD
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            
            if let error = error {
                print("Failed to create user: ", error)
                return
            }
            
            print("Successfully created user: ", user?.uid ?? "")
            
            // STEP 2: UPLOAD IMAGE TO FIREBASE STORAGE
            guard let image = self.addPhotoButton.imageView?.image else { return }
            guard let uploadData = UIImageJPEGRepresentation(image, 0.4) else { return }
            let filename = NSUUID().uuidString //or perhaps "\(uid)_profile_picture?"
            Storage.storage().reference().child("profile_pictures").child(filename).putData(uploadData, metadata: nil, completion: { (metadata, error) in
                if let error = error {
                    print("Failed to upload profile picture: ", error)
                }
                guard let profilePictureURL = metadata?.downloadURL()?.absoluteString else { return }
                print("Succesfully uploaded profile image: ", profilePictureURL)
                
                // STEP 3: SAVE A DICTIONARY FULL OF USER INFO UNDER THE UID YOU CREATED
                guard let uid = user?.uid else { return }
                let profileValues = ["username": username, "profile_picture_URL": profilePictureURL]
                let values = [uid: profileValues]
                
                Database.database().reference().child("users").updateChildValues(values, withCompletionBlock: { (error2, reference) in
                    
                    if let error2 = error2 {
                        print("Failed to save user info into database", error2)
                        return
                    }
                    
                    print("Sucecessfully saved user info into the database")
                    
                })
                
            })
            
            
            
        
        }
    }
    
    @objc func makeSignupButtonGreen() {
        let isFormValid = emailField.text?.characters.count ?? 0 > 0 &&
        usernameField.text?.characters.count ?? 0 > 0 &&
        passwordField.text?.characters.count ?? 0 > 0
        
        if isFormValid {
            signupButton.backgroundColor = #colorLiteral(red: 0.1803921569, green: 0.8, blue: 0.4431372549, alpha: 1)
            signupButton.isEnabled = true
        } else {
            signupButton.backgroundColor = #colorLiteral(red: 0.434607031, green: 0.6871443467, blue: 0.8588235294, alpha: 1)
            signupButton.isEnabled = false
        }
    }

}

extension SignupVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func presentImagePicker() {
        var imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = info[UIImagePickerControllerEditedImage] as? UIImage else {return}
        addPhotoButton.setImage(image, for: .normal)
        
        addPhotoButton.layer.cornerRadius = addPhotoButton.frame.width / 2
        addPhotoButton.layer.masksToBounds = true
        addPhotoButton.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        addPhotoButton.layer.borderWidth = 3
        
        dismiss(animated: true, completion: nil)
    }
    
}
