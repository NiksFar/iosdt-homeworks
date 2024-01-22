//
//  TabbarController.swift
//  Navigation
//
//  Created by Никита on 17.02.2023.
//

import UIKit

class TabBarController: UITabBarController {
    
    var feedTabNavigationController: UINavigationController!
    var profileTabNavigationController: UINavigationController!
    var favoritePostTabNavigationController: UINavigationController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        
        feedTabNavigationController = UINavigationController.init(rootViewController: FeedViewController())
        let loginInspector = MyLoginFactory().makeLoginInspector()
        profileTabNavigationController = UINavigationController(rootViewController: LogInViewController(service: loginInspector))
        favoritePostTabNavigationController = UINavigationController(rootViewController: PostViewController())
        
        self.viewControllers = [feedTabNavigationController, profileTabNavigationController, favoritePostTabNavigationController]
        
        let item1 = UITabBarItem(title: "Feed", image: UIImage(systemName: "newspaper.circle"), tag: 0)
        let item2 = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.crop.circle"), tag: 1)
        let item3 = UITabBarItem(title: "Post", image: UIImage(systemName: "star.circle"), tag: 2)
        
        feedTabNavigationController.tabBarItem = item1
        profileTabNavigationController.tabBarItem = item2
        favoritePostTabNavigationController.tabBarItem = item3
        
        UITabBar.appearance().backgroundColor = .systemOrange
        
    }
}
