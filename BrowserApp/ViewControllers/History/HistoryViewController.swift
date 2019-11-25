//
//  HistoryViewController.swift
//  BrowserApp
//
//  Created by admin on 25/11/2019.
//  Copyright © 2019 nxsang063@gmail.com. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {

    private lazy var doneBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneDidClick))
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "History"
        navigationItem.rightBarButtonItem = doneBarButtonItem
    }

    @objc func doneDidClick() {
        self.dismiss(animated: true, completion: nil)
    }
}
