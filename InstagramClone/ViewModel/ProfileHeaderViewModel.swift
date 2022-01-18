//
//  ProfileHeaderViewModel.swift
//  InstagramClone
//
//  Created by User on 2022/01/18.
//

import Foundation

struct ProfileHeaderViewModel {
    let user: User
    
    var fullname: String {
        return user.fullname
    }
    
    var profileImageUrl: URL? {
        return URL(string: user.profileImage)
    }
    
    init(user: User) {
        self.user = user
    }
}
