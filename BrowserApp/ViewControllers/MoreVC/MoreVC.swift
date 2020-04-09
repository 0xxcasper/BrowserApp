//
//  MoreVC.swift
//  BrowserApp
//
//  Created by SangNX on 11/24/19.
//  Copyright © 2019 nxsang063@gmail.com. All rights reserved.
//

import UIKit

class MoreVC: UIViewController {

    @IBOutlet weak var tbView: UITableView!
    let headerFirst = HeaderMore()
    let headerSecond = HeaderMore()
    let headerThird = HeaderMore()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }

    func setupView() {
        tbView.delegate = self
        tbView.dataSource = self
        tbView.separatorStyle = .none
        tbView.registerXibFile(SwitchCell.self)
        tbView.registerXibFile(DefaultCell.self)
        title = "More"
    }

}


extension MoreVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0, 1:
            return 1
        default:
            return 2
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        switch indexPath.section {
        case 0:
            cell = tableView.dequeue(DefaultCell.self, for: indexPath)
            (cell as! DefaultCell).setupCell(type: .PASS_CODE)
            (cell as! DefaultCell).delegate = self
            break
        case 1:
            cell = tableView.dequeue(SwitchCell.self, for: indexPath)
            (cell as! SwitchCell).setupCell(type: .VPN, isOn: true)
            (cell as! SwitchCell).delegate = self
            break
        default:
            switch indexPath.row {
            case 0:
                cell = tableView.dequeue(SwitchCell.self, for: indexPath)
                (cell as! SwitchCell).setupCell(type: .ADBLOCK, isOn: true)
                (cell as! SwitchCell).delegate = self
                break
            default:
                cell = tableView.dequeue(DefaultCell.self, for: indexPath)
                (cell as! DefaultCell).setupCell(type: .CLEAR_HISTORY)
                (cell as! DefaultCell).delegate = self
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 0
        case 1:
            return 25
        default:
            return 45
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            return headerFirst
        case 1:
            return headerSecond
        default:
            headerThird.lblTitle.text = "BROWSER"
            return headerThird
        }
    }
}


extension MoreVC: DefaultCellDelegate, SwitchCellDelegate {
    func selectedCellDefault(type: DefaultCellType) {
        switch type {
        case .CLEAR_HISTORY:
            self.showAlert()
            break
        default:
            break
        }
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Warning", message: "Do you want to delete all history?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancelAction)
        
        let delete = UIAlertAction(title: "Delete", style: .destructive) { (UIAlertAction) in
            if(HistoryModel.getAll().count > 0) {
                HistoryModel.getAll().forEach { (value) in
                    value.delete()
                }
            }
            let alertDone = UIAlertController(title: "Success", message: "Delete history success!", preferredStyle: .alert)
            alertDone.addAction(UIKit.UIAlertAction(title: "Done", style: .cancel, handler: nil))
            self.present(alertDone, animated: true, completion: nil)
        }
        alert.addAction(delete)
        self.present(alert, animated: true, completion: nil)
    }
    
    //Do Something with Switch
    func onChangeSwitch(_ isOn: Bool) {
    }
    
    
}
