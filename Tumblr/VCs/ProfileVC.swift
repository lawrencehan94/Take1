//
//  ProfileVC.swift
//  Tumblr
//
//  Created by Lawrence Han on 10/1/17.
//  Copyright © 2017 Lawrence Han. All rights reserved.
//

import UIKit
import Firebase

class ProfileVC: UIViewController {

    @IBOutlet weak var headerLabel: UILabel!
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var postCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var editProfileButton: UIButton!
    @IBOutlet weak var buttonViewBackground: UIView!
    
    @IBOutlet weak var collectionView: UICollectionView!

    @IBAction func gearButtonPressed(_ sender: UIButton) {
        logout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLogoutStatus()
        fetchCurrentUserInfo()
        styleUI()
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
    
    func styleUI() {
        profilePicture.layer.cornerRadius = profilePicture.frame.width / 2
        profilePicture.clipsToBounds = true
        editProfileButton.layer.borderColor = #colorLiteral(red: 0.4078193307, green: 0.4078193307, blue: 0.4078193307, alpha: 1)
        editProfileButton.layer.borderWidth = 1
        editProfileButton.layer.cornerRadius = 3
        buttonViewBackground.layer.borderColor = #colorLiteral(red: 0.4078193307, green: 0.4078193307, blue: 0.4078193307, alpha: 1)
        buttonViewBackground.layer.borderWidth = 1
    }
    
    func fetchCurrentUserInfo() {
        guard let currentUID = Auth.auth().currentUser?.uid else {return}
        Database.database().reference().child("users").child(currentUID).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else {return}
            self.user = User(dictionary: dictionary)
            self.headerLabel.text = self.user?.username
            self.usernameLabel.text = self.user?.username
            self.collectionView.reloadData()
            
        }) { (error) in
            print("Failed to get current user: ", error)
        }
    }
    
    var user: User? {
        didSet {
            getProfilePicture()
        }
    }
    
    func getProfilePicture() {
        guard let urlString = user?.profilePictureURL else {return}
        guard let url = URL(string: urlString) else {return}
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Failed to retrive profile image")
                return
            }
            guard let data = data else { return }
            let image = UIImage(data: data)
            
            DispatchQueue.main.async {
                self.profilePicture.image = image
            }
            
        }.resume()
    }
    
    func logout() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let logout = UIAlertAction(title: "Log Out", style: .destructive, handler: {(_) in
            do {
                try Auth.auth().signOut()
                self.checkLogoutStatus()
            } catch {
                print("Failed to sign out")
            }
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(logout)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    func checkLogoutStatus() {
        if Auth.auth().currentUser == nil {
            let loginSB = UIStoryboard(name: "Login", bundle: nil)
            let loginVC = loginSB.instantiateViewController(withIdentifier: "LoginVC")
            present(loginVC, animated: true, completion: nil)
        }
    }
}

extension ProfileVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath)
        cell.backgroundColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width-2) / 3
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    

    
}
