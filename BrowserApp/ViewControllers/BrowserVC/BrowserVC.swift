//
//  BrowserVC.swift
//  BrowserApp
//
//  Created by SangNX on 11/24/19.
//  Copyright © 2019 nxsang063@gmail.com. All rights reserved.
//

import UIKit
import MobileCoreServices

class BrowserVC: SafariViewController {

    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name.isUrlFile, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.receivedNotificationIsURLFile(notification:)), name: Notification.Name.isUrlFile, object: nil)
        self.tabBarController?.tabBar.barTintColor = .white
    }
    
    override func historyDidClick() {
        let historyVC = UINavigationController(rootViewController: HistoryViewController())
        self.present(historyVC, animated: true, completion: nil)
    }
    
    override func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // API Google
    }
    
    override func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
        if searchText.verifyUrl() {
            self.url = URL(string: searchText)
        } else {
            self.url = URL(string: "https://www.google.com/search?q=\(searchText.replacingOccurrences())")
        }
    }
    
    @objc func receivedNotificationIsURLFile(notification: Notification) {
        if let name = notification.userInfo?["name"] as? String, let url = notification.userInfo?["url"] as? String {
            let optionMenu = UIAlertController(title: nil, message: name, preferredStyle: .actionSheet)

            let downloadAction = UIAlertAction(title: "Download", style: .default) { (UIAlertAction) in
                NotificationCenter.default.post(name: Notification.Name.beginDownload, object: nil, userInfo: ["url": url])
            }
            
            let copyAction = UIAlertAction(title: "Copy Link", style: UIAlertAction.Style.default) { (UIAlertAction) in
                self.copyToClipBoard(textToCopy: url)
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            optionMenu.addAction(downloadAction)
            optionMenu.addAction(copyAction)
            optionMenu.addAction(cancelAction)
            self.present(optionMenu, animated: true, completion: nil)
        }
    }
    
    private func copyToClipBoard(textToCopy: String) {
        let pasteBoard = UIPasteboard.general
        pasteBoard.setValue(textToCopy, forPasteboardType: kUTTypePlainText as String)
    }
}
