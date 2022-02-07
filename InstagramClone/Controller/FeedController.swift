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
    
    private var posts = [Post]()
    
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
        PostService.fetchPosts { posts in
            self.posts = posts
            self.collectionView.refreshControl?.endRefreshing()
            self.collectionView.reloadData()
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
    func cell(_ cell: FeedCell, wantsToShowCommentsFor post: Post) {
        let controller = CommentController(collectionViewLayout: UICollectionViewFlowLayout())
        navigationController?.pushViewController(controller, animated: true)
    }
    
}
