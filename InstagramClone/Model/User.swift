//
//  User.swift
//  InstagramClone
//
//  Created by User on 2022/01/18.
//

import Foundation

struct User {
    let email: String
    let fullname: String
    let profileImage: String
    let username: String
    let uid: String
    
    init(dictionary: [String: Any]) {
        self.email = dictionary["email"] as? String ?? ""
        self.fullname = dictionary["fullname"] as? String ?? ""
        self.profileImage = dictionary["profileImageUrl"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
    }
    
}