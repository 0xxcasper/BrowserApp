//
//  SwitchCell.swift
//  BrowserApp
//
//  Created by Sang on 4/9/20.
//  Copyright © 2020 nxsang063@gmail.com. All rights reserved.
//

import UIKit

enum SwitchCellType {
    case VPN
    case ADBLOCK
}

protocol SwitchCellDelegate: class {
    func onChangeSwitch(_ isOn: Bool)
}
class SwitchCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var switchView: UISwitch!
    @IBOutlet weak var lineView: UIView!
    
    var type: SwitchCellType! {
        didSet {
            switch type {
            case .VPN:
                lblTitle.text = "VPN"
                lineView.isHidden = true
                break
            default:
                lblTitle.text = "Ad Block"
                lineView.isHidden = false
                break
            }
        }
    }
    weak var delegate: SwitchCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @IBAction func changeSwitch(_ sender: UISwitch) {
        delegate?.onChangeSwitch(sender.isOn)
    }
    
    func setupCell(type: SwitchCellType = .VPN, isOn: Bool = true) {
        self.type = type
        self.switchView.isOn = isOn
    }
    
}
