//
//  UserService.swift
//  InstagramClone
//
//  Created by User on 2022/01/18.
//

import Firebase

// 현재 사용중인 유저 정보 가져오기
struct UserService {
    static func fetchUser(completion: @escaping(User) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        COLLECTION_USERS.document(uid).getDocument { snapshot, error in
            guard let dictionary = snapshot?.data() else { return }
            
            let user = User(dictionary: dictionary)
            completion(user)
        }
    }
}
