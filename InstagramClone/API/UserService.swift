//
//  UserService.swift
//  InstagramClone
//
//  Created by User on 2022/01/18.
//

import Firebase

struct UserService {
    
    // 현재 사용중인 유저 정보 가져오기
    static func fetchUser(completion: @escaping(User) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        COLLECTION_USERS.document(uid).getDocument { snapshot, error in
            guard let dictionary = snapshot?.data() else { return }
            
            let user = User(dictionary: dictionary)
            completion(user)
        }
    }
    
    // 전체 유저 정보 가져오기
    static func fetchUsers(completion: @escaping([User])->Void) {
        COLLECTION_USERS.getDocuments { snapshot, error in
            guard let snapshot = snapshot else { return }
            
            // users 는 User 객체들로 구성된 어레이 (map 함수를 이용하여 document의 data를 User 객체로 변환)
            let users = snapshot.documents.map({ User(dictionary: $0.data()) })
            completion(users)
        }
    }
    
}

