//
//  FeedController.swift
//  InstagramClone
//
//  Created by User on 2022/01/06.
//

import UIKit
import Firebase

private let reuseIdentifier = "Cell"


class FeedController: UICollectionViewController {
    
    //MARK: - Properties
    
    private var posts = [Post]() {
        didSet { collectionView.reloadData() }
    }
    
    var post: Post?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchPosts()
    }
    
    //MARK: - Actions
    
    @objc func handleRefresh() {
        fetchPosts()
    }
    
    @objc func handleLogout() {
        do {
            try Auth.auth().signOut()
            let controller = LoginController()
            controller.delegate = self.tabBarController as? MainTabController
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        } catch {
            print("DEBUG: Failed to sign out")
        }
    }
    
    //MARK: - API
    
    func fetchPosts() {
        guard post == nil else { return } // feed 화면에서 보여주어야 할 feed가 특정한 한개의 post라면 모든 post를 불러올 필요 x

        PostService.fetchFeedPosts { posts in
            self.posts = posts
            self.collectionView.refreshControl?.endRefreshing()
            self.checkIfUserLikedPost()
        }
    }
    
    func checkIfUserLikedPost() {
        self.posts.forEach { post in
            PostService.checkIfUserLikedPost(post: post) { didLike in
                // 사용자가 해당 post를 like하고 있다면 post객체의 didLike 프로퍼티를 true로 수정해야 한다.
                // 이를 위해 posts 배열에서 해당되는 post의 위치(인덱스)를 firstIndex() 함수를 통해 찾아내고 배열에서 해당 인덱스로 직접 접근하여 didLike를 수정한다.
                if let index = self.posts.firstIndex(where: { $0.postID == post.postID }) {
                    self.posts[index].didLike = didLike
                }
            }
        }
    }
    
    //MARK: - Helpers
    
    func configureUI() {
        collectionView.backgroundColor = .white
        // 콜렉션 뷰에 cell 등록
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        if post == nil {
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        }
        
        navigationItem.title = "Feed"
        
        // 화면 스크롤을 하면 새롭게 posts들 fetch하기 위한 refresher 생성
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = refresher
    }
}

//MARK: - UICollectionViewDataSource

extension FeedController {
    
    // collectionView에 들어갈 아이템의 개수 정의
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return post == nil ? posts.count : 1
    }
    // collectionView의 각 cell을 정의
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FeedCell
        cell.delegate = self
        
        if let post = post {
            cell.viewModel = PostViewModel(post: post)
            
        } else {
            cell.viewModel = PostViewModel(post: posts[indexPath.row])
        }
        
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
// 각 cell의 크기 정의
extension FeedController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // 미리 feed의 크기를 정해야 한다. 여기서 8은 padding 될 값이다. 40은 프로필 이미지 크기이다.
        let width = view.frame.width
        var height = width + 8 + 40 + 8
        height += 50
        height += 60
        
        return CGSize(width: width, height: height)
    }
}


//MARK: - FeedCellDelegate
extension FeedController: FeedCellDelegate {
    func cell(_ cell: FeedCell, wantsToShowProfileFor uid: String) {
        UserService.fetchUser(withUid: uid) { user in
            let controller = ProfileController(user: user)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    
    func cell(_ cell: FeedCell, wantsToShowCommentsFor post: Post) {
        let controller = CommentController(post: post)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    // Feed(post)의 좋아요 버튼을 눌렀을 때 좋아요 or 좋아요 해제 처리
    func cell(_ cell: FeedCell, didLike post: Post) {
        cell.viewModel?.post.didLike.toggle()
        
        // MainTabController로 부터 현재 로그인하여 사용중인 유저 객체를 가져옴
        guard let tab = tabBarController as? MainTabController else { return }
        guard let currentUser = tab.user else { return }
        
        if post.didLike {
            PostService.unlikePost(post: post) { error in
                if let error = error {
                    print("DEBUG: Failed to unlike post with \(error.localizedDescription)")
                }
                cell.likeButton.setImage(#imageLiteral(resourceName: "like_unselected"), for: .normal)
                cell.likeButton.tintColor = .black
                cell.viewModel?.post.likes = post.likes - 1
            }
        } else {
            PostService.likePost(post: post) { error in
                if let error = error {
                    print("DEBUG: Failed to like post with \(error.localizedDescription)")
                }
                cell.likeButton.setImage(#imageLiteral(resourceName: "like_selected"), for: .normal)
                cell.likeButton.tintColor = .red
                cell.viewModel?.post.likes = post.likes + 1
                
                NotificationService.uploadNotification(toUid: post.ownerUid,
                                                       fromUser: currentUser,
                                                       type: .like,
                                                       post: post)
            }
        }
    }
}
