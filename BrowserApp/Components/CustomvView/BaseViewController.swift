//
//  BaseViewController.swift
//  BrowserApp
//
//  Created by admin on 26/11/2019.
//  Copyright © 2019 nxsang063@gmail.com. All rights reserved.
//

import Foundation
import UIKit
import Files
class BaseViewController: UIViewController {
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    private lazy var addBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editDidClick))
    }()
    private lazy var editBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addDidClick))
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesSearchBarWhenScrolling = false
        let cancelButtonAttributes = [NSAttributedString.Key.foregroundColor: self.view.tintColor]
        UIBarButtonItem.appearance().setTitleTextAttributes(cancelButtonAttributes as [NSAttributedString.Key : Any] , for: .normal)
    }
    
    func addLeftBarButton() {
        navigationItem.rightBarButtonItem = editBarButtonItem
    }
    
    func addRightBarButton() {
        navigationItem.leftBarButtonItem = addBarButtonItem
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
    
    func showActionSheet(item: DownloadModel, hasDelete: Bool = true, successPaste: @escaping (()->Void), successMoving: @escaping (()->Void), successDelete: @escaping (()->Void)) {
        let settingsActionSheet: UIAlertController = UIAlertController(title:nil, message:nil, preferredStyle:UIAlertController.Style.actionSheet)
        if(fileMove != nil) {
            settingsActionSheet.addAction(UIAlertAction(title:"Paste", style:UIAlertAction.Style.default, handler:{ action in
                let targetFolder = URL(string: item.urlStr + fileMove!.name)!.path
                let originFolder = URL(string: fileMove!.urlStr)!.path
                let fileManager = FileManager.default
                do {
                    try fileManager.moveItem(atPath: originFolder, toPath: targetFolder)
                } catch {
                    print("Ooops! Something went wrong: \(error)")
                }
            }))
        }
        settingsActionSheet.addAction(UIAlertAction(title:"Moving", style:UIAlertAction.Style.default, handler:{ action in
            fileMove = item
        }))

        //Delete
        settingsActionSheet.addAction(UIAlertAction(title:"Delete", style:UIAlertAction.Style.destructive, handler:{ action in
            let fileManager = FileManager.default
            do {
                try fileManager.removeItem(atPath: URL(string: item.urlStr)!.path)
            } catch {
                print("\(error)")
            }
            successDelete()
        }))

        settingsActionSheet.addAction(UIAlertAction(title:"Cancel", style:UIAlertAction.Style.cancel, handler:nil))
        present(settingsActionSheet, animated:true, completion:nil)
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

