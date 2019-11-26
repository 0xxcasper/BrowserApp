//
//  NewTabTableViewCell.swift
//  BrowserApp
//
//  Created by admin on 26/11/2019.
//  Copyright © 2019 nxsang063@gmail.com. All rights reserved.
//

import UIKit

protocol NewTabTableViewCellDelegate: class {
    func removeTab( indexP: IndexPath)
}

class NewTabTableViewCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    weak var delegate: NewTabTableViewCellDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .none
    }
    
    @IBAction func handleRemoveTab(_ sender: UIButton) {
        if let indexP = self.indexPath {
            delegate.removeTab(indexP: indexP)
        }
    }
    
}
