//
//  DownloadTableViewCell.swift
//  BrowserApp
//
//  Created by admin on 25/11/2019.
//  Copyright © 2019 nxsang063@gmail.com. All rights reserved.
//

import UIKit

class DownloadTableViewCell: UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.selectionStyle = .none
    }
    
    func setDataCell( down: DownloadModel) {
        lblTitle.text = down.name
        lblStatus.text = down.progress == 100 ? "Completed" : "Downloading"
        progressView.isHidden = down.progress == 100 ? true : false
        progressView.setProgress(Float(down.progress), animated: true)
    }
}
