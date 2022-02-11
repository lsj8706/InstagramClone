//
//  CommentViewModel.swift
//  InstagramClone
//
//  Created by User on 2022/02/11.
//

import UIKit

struct CommentViewModel {
    
    private let comment: Comment
    
    var profileImageUrl: URL? { return URL(string: comment.profileImageUrl) }
    
    var username: String { return comment.username }
    
    var commentText: String { return comment.commentText }
    
    init(comment: Comment) {
        self.comment = comment
    }
    
    func commentLabelText() -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: "\(username) ", attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        
        attributedString.append(NSAttributedString(string: commentText, attributes: [.font: UIFont.systemFont(ofSize: 14)]))
        
        return attributedString
    }
    
    // 댓글의 길이에 맞게 cell의 크기를 조절하기 위해 또다른 UILabel을 만들어서 해당 Label의 크기를 사용 (댓글이 길면 cell의 높이가 길어지게)
    func size(forWidth width:CGFloat) -> CGSize {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = comment.commentText
        label.lineBreakMode = .byWordWrapping
        label.setWidth(width)
        return label.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }
    
}
