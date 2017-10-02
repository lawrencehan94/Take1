//
//  LoginVC.swift
//  Tumblr
//
//  Created by Lawrence Han on 10/1/17.
//  Copyright © 2017 Lawrence Han. All rights reserved.
//

import UIKit
import Firebase

class LoginVC: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        loginUser()
    }
    
    @IBAction func signupButtonPressed(_ sender: UIButton) {
        let loginSB = UIStoryboard(name: "Login", bundle: nil)
        let signupVC = loginSB.instantiateViewController(withIdentifier: "SignupVC")
        present(signupVC, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailField.addTarget(self, action: #selector(makeSignupButtonGreen), for: .editingChanged)
        passwordField.addTarget(self, action: #selector(makeSignupButtonGreen), for: .editingChanged)

    }
    
    func loginUser() {
        guard let email = emailField.text, email.characters.count > 0 else { return }
        guard let password = passwordField.text, password.characters.count > 0 else { return }
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil {
                print("Error signing in", error)
            }
            print("success")
            if let _ = user {
                let profileSB = UIStoryboard(name: "Profile", bundle: nil)
                let profileVC = profileSB.instantiateViewController(withIdentifier: "ProfileVC")
                self.present(profileVC, animated: true, completion: nil)
            }
        }
    }
    
    @objc func makeSignupButtonGreen() {
        let isFormValid = emailField.text?.characters.count ?? 0 > 0 &&
            passwordField.text?.characters.count ?? 0 > 0
        
        if isFormValid {
            loginButton.backgroundColor = #colorLiteral(red: 0.1803921569, green: 0.8, blue: 0.4431372549, alpha: 1)
            loginButton.isEnabled = true
        } else {
            loginButton.backgroundColor = #colorLiteral(red: 0.434607031, green: 0.6871443467, blue: 0.8588235294, alpha: 1)
            loginButton.isEnabled = false
        }
    }


}
