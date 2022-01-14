//
//  AuthService.swift
//  InstagramClone
//
//  Created by User on 2022/01/14.
//

import UIKit
import Firebase

struct AuthCredentials {
    let email: String
    let password: String
    let fullname: String
    let username: String
    let profileImage: UIImage
}


struct AuthService {
    static func registerUser(withCredeitial credentials: AuthCredentials) {
        print("DEBUG: Credentials are \(credentials)")
    }
}
