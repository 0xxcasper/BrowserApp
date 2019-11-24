//
//  HomeVC.swift
//  BrowserApp
//
//  Created by SangNX on 11/24/19.
//  Copyright © 2019 nxsang063@gmail.com. All rights reserved.
//

import UIKit

class HomeVC: UITabBarController {

    private let foldersVC   = FoldersVC()
    private let browserVC   = BrowserVC()
    private let downloadsVC = DownloadsVC()
    private let moreVC      = MoreVC()
    private var tabBarList: [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabbarView()
    }
    
    private func setupTabbarView() {
        foldersVC.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 0)
        browserVC.tabBarItem = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 1)
        downloadsVC.tabBarItem = UITabBarItem(tabBarSystemItem: .downloads, tag: 2)
        moreVC.tabBarItem = UITabBarItem(tabBarSystemItem: .more, tag: 3)
        
        tabBarList = [foldersVC, browserVC, downloadsVC, moreVC]
        viewControllers = tabBarList
    }
    
}
