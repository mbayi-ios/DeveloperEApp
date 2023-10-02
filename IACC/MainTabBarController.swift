//
//  MainTabBarController.swift
//  IACC
//
//  Created by Ambrose Mbayi on 02/10/2023.
//

import Foundation
import UIKit

class MainTabBarController: UITabBarController {
    convenience init() {
        self.init(nibName: nil, bundle: nil)
        self.setUpViewController()
    }
    
    private func setUpViewController() {
        viewControllers = [
            makeNav(for: makeFriendsList(), title: "Friends", icon: "person.2.fill"),
            
        ]
    }
    
    private func makeNav(for vc: UIViewController, title: String, icon: String) -> UIViewController {
        vc.navigationItem.largeTitleDisplayMode = .always
        
        let nav = UINavigationController(rootViewController: vc)
        nav.tabBarItem.image = UIImage(systemName: icon, withConfiguration: UIImage.SymbolConfiguration(scale: .large))
        nav.tabBarItem.title = title
        nav.navigationBar.prefersLargeTitles = true
        return nav
    }
    
    
    private func makeFriendsList() -> ListViewController {
        let vc = ListViewController()
        vc.fromFriendsScreen = true
        return vc
    }
}
