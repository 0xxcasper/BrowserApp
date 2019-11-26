//
//  HistoryViewController.swift
//  BrowserApp
//
//  Created by admin on 25/11/2019.
//  Copyright © 2019 nxsang063@gmail.com. All rights reserved.
//

import UIKit
import RealmSwift

protocol HistoryViewControllerDelegate: class {
    func didSelectHistory( url: String)
}

class HistoryViewController: UIViewController {

    @IBOutlet weak var tbView: UITableView!
    private var historyList: [HistoryModel]?
    private lazy var doneBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneDidClick))
    }()
    weak var delegate: HistoryViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "History"
        navigationItem.rightBarButtonItem = doneBarButtonItem
        tbView.registerXibFile(HistoryTableViewCell.self)
        tbView.delegate = self
        tbView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        historyList = HistoryModel.getAll()
        tbView.reloadData()
    }

    @objc func doneDidClick() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (historyList != nil && historyList!.count > 0) ? historyList!.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbView.dequeue(HistoryTableViewCell.self, for: indexPath)
        cell.lblTitle.text = historyList![indexPath.row].name
        cell.lblUrl.text = historyList![indexPath.row].url
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            let value = historyList![indexPath.row]
            value.delete()
            historyList = HistoryModel.getAll()
            tbView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate.didSelectHistory(url: historyList![indexPath.row].url)
        self.dismiss(animated: true, completion: nil)
    }
}
