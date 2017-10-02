//
//  User.swift
//  Tumblr
//
//  Created by Lawrence Han on 10/1/17.
//  Copyright © 2017 Lawrence Han. All rights reserved.
//

struct User {
    let username: String
    let profilePictureURL: String
    
    init(dictionary: [String: Any]) {
        self.username = dictionary["username"] as? String ?? ""
        self.profilePictureURL = dictionary["profile_picture_URL"] as? String ?? ""
    }
    
}
