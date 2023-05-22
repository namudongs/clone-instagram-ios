//
//  MainTabController.swift
//  InstagramFirebaseTutorial
//
//  Created by namdghyun on 2023/05/22.
//

import UIKit
import Firebase

class MainTabController: UITabBarController {
    
    // MARK: - 생명주기
    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfUserIsLoggedIn()
        configureViewControllers()
//        logout()
    }
    
    // MARK: - API
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let controller = LoginController()
                let nav = UINavigationController(rootViewController: controller)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: false, completion: nil)
            }
        }
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("디버그: 로그아웃에 실패했습니다.")
        }
    }
    
    // MARK: - 도우미
    
    func configureViewControllers() {
        view.backgroundColor = .white
        tabBar.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        tabBar.backgroundColor = .white
        tabBar.isTranslucent = true
        
        let layout = UICollectionViewFlowLayout()
        let feed = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "home_unselected"), selectedImage: #imageLiteral(resourceName: "home_selected"), rootViewController: FeedController(collectionViewLayout: layout))
        
        let search = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "search_unselected"), selectedImage: #imageLiteral(resourceName: "search_selected"), rootViewController: SearchController())
        
        let imageSelector = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "plus_unselected"), selectedImage: #imageLiteral(resourceName: "plus_unselected"), rootViewController: ImageSelectorController())
        
        let notifications = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "like_unselected"), selectedImage: #imageLiteral(resourceName: "like_selected"), rootViewController: NotificationController())
        
        let profileLayout = UICollectionViewFlowLayout()
        let profile = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "profile_unselected"), selectedImage: #imageLiteral(resourceName: "profile_selected"), rootViewController: ProfileController(collectionViewLayout: profileLayout))
        
        viewControllers = [feed, search, imageSelector, notifications, profile]
        
        
    }
    
    func templateNavigationController(unselectedImage: UIImage, selectedImage: UIImage, rootViewController: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = unselectedImage
        nav.tabBarItem.selectedImage = selectedImage
//        nav.navigationBar.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        return nav
        
    }
    
}
