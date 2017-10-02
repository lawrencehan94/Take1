//
//  ViewController.swift
//  Tumblr
//
//  Created by Lawrence Han on 9/28/17.
//  Copyright © 2017 Lawrence Han. All rights reserved.
//

import UIKit
import Firebase

class OnboardingVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkLogoutStatus()
    }
    
    func checkLogoutStatus() {
        if Auth.auth().currentUser == nil {
            let loginSB = UIStoryboard(name: "Login", bundle: nil)
            let loginVC = loginSB.instantiateViewController(withIdentifier: "LoginVC")
            present(loginVC, animated: false, completion: nil)
        } else {
            let profileSB = UIStoryboard(name: "Profile", bundle: nil)
            let profileVC = profileSB.instantiateViewController(withIdentifier: "ProfileVC")
            present(profileVC, animated: false, completion: nil)
        }
    }


}

