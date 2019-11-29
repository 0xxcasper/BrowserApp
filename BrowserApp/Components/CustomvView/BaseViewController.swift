//
//  BaseViewController.swift
//  BrowserApp
//
//  Created by admin on 26/11/2019.
//  Copyright © 2019 nxsang063@gmail.com. All rights reserved.
//

import Foundation
import UIKit

class BaseViewController: UIViewController {
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    private lazy var addBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addDidClick))
    }()
    private lazy var editBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editDidClick))
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesSearchBarWhenScrolling = false
        let cancelButtonAttributes = [NSAttributedString.Key.foregroundColor: self.view.tintColor]
        UIBarButtonItem.appearance().setTitleTextAttributes(cancelButtonAttributes as [NSAttributedString.Key : Any] , for: .normal)
    }
    
    func addLeftBarButton() {
        navigationItem.leftBarButtonItem = addBarButtonItem
    }
    
    func addRightBarButton() {
        navigationItem.rightBarButtonItem = editBarButtonItem

    }
    
    func setUpSearchBar() {
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.searchBar.placeholder = "Search downloads"
        self.searchController.searchBar.delegate = self
        self.definesPresentationContext = false
        self.searchController.searchBar.searchTextField.tintColor = .blue

        self.navigationItem.searchController = searchController
    }
    
    @objc func addDidClick() {
        
    }
    
    @objc func editDidClick() {
        
    }
}

//MARK: - UISearchBarDelegate's Method

extension BaseViewController: UISearchBarDelegate
{
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)    {
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
    }
}

