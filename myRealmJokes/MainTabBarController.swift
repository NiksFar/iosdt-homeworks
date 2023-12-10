//
//  MainTabBarController.swift
//  myRealmJokes
//
//  Created by Никита on 09.12.2023.
//

import Foundation
import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let vc1 = LoadJokeController()
        vc1.tabBarItem.title = "Load"
        vc1.tabBarItem.image = UIImage(systemName: "square.and.arrow.down")
        let vc2 = SortedListController()
        vc2.tabBarItem.title = "Sort"
        vc2.tabBarItem.image = UIImage(systemName: "list.bullet.clipboard")
        let vc3 = CategoryJokeController()
        vc3.tabBarItem.title = "Category"
        vc3.tabBarItem.image = UIImage(systemName: "list.star")
        self.viewControllers = [vc1, vc2, vc3]
        self.tabBar.backgroundColor = .systemYellow
    }
    
}
