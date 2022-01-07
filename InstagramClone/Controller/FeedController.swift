//
//  FeedController.swift
//  InstagramClone
//
//  Created by User on 2022/01/06.
//

import UIKit

private let reuseIdentifier = "Cell"


class FeedController: UICollectionViewController {
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    //MARK: - Helpers
    
    func configureUI() {
        collectionView.backgroundColor = .white
        // 콜렉션 뷰에 cell 등록
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
}

//MARK: - UICollectionViewDataSource

extension FeedController {
    
    // collectionView에 들어갈 아이템의 개수 정의
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    // collectionView의 각 cell을 정의
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FeedCell
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
