//
//  CommentService.swift
//  InstagramClone
//
//  Created by User on 2022/02/10.
//

import Firebase

struct CommentService {
    
    // 댓글 업로드
    static func uploadComment(comment: String, postID: String, user: User, completion: @escaping(FirestoreCompletion)) {
        
        let data: [String: Any] = ["uid": user.uid,
                                   "comment": comment,
                                   "timestamp": Timestamp(date: Date()),
                                   "username": user.username,
                                   "profileImageUrl": user.profileImageUrl]
        
        COLLECTION_POSTS.document(postID).collection("comments").addDocument(data: data, completion: completion)
        
    }
    
    // 해당 포스트의 댓글들 전부 가져오기
    static func fetchComments(forPost postID: String, completion: @escaping(([Comment])->Void)) {
        var comments = [Comment]()
        let query = COLLECTION_POSTS.document(postID).collection("comments").order(by: "timestamp", descending: false)
        
        
        // 댓글이 새롭게 추가 되면 이를 트래킹하여 comments 어레이에 자동 추가
        query.addSnapshotListener { snapshot, error in
            snapshot?.documentChanges.forEach({ change in
                if change.type == .added {
                    let data = change.document.data()
                    let comment = Comment(dictionary: data)
                    comments.append(comment)
                }
            })
            
            completion(comments)
        }
    }
}
