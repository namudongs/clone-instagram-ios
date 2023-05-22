//
//  FeedController.swift
//  InstagramFirebaseTutorial
//
//  Created by namdghyun on 2023/05/22.
//

import UIKit
import Firebase

private let reuseIdentifier = "Cell"

class FeedController: UICollectionViewController {
    
    // MARK: - 속성
    private var logOutButton: UIBarButtonItem {
        let button = UIBarButtonItem(title: "로그아웃")
        button.style = .done
        button.target = self
        button.action = #selector(handleLogout)
        button.tintColor = .red
        return button
    }
    
    // MARK: - 생명주기
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - 액션
    @objc func handleLogout() {
        do {
            try Auth.auth().signOut()
            let controller = LoginController()
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        } catch {
            print("디버그: 로그아웃에 실패했습니다.")
        }
    }
    
    // MARK: - 도우미
    func configureUI() {
        collectionView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        navigationItem.setLeftBarButton(logOutButton, animated: true)
        navigationItem.title = "피드"
        
    }
}

// MARK: - 컬렉션뷰 기본설정
extension FeedController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FeedCell
        return cell
    }
}


// MARK: -  컬렉션뷰 사이즈 설정
extension FeedController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = view.frame.width
        var height = width + 8 + 40 + 8
        height += 50
        height += 60
        
        return CGSize(width: width, height: height)
    }
}
