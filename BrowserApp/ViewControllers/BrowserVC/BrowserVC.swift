//
//  BrowserVC.swift
//  BrowserApp
//
//  Created by SangNX on 11/24/19.
//  Copyright © 2019 nxsang063@gmail.com. All rights reserved.
//

import UIKit

class BrowserVC: SafariViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBarController?.tabBar.barTintColor = .white
    }
    
    override func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
    
    override func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
        if searchText.verifyUrl() {
            self.url = URL(string: searchText)
        } else {
            self.url = URL(string: "https://www.google.com/search?q=\(searchBar.text ?? "")")
        }
    }
}
