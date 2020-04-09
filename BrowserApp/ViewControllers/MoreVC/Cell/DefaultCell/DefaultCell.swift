//
//  DefaultCell.swift
//  BrowserApp
//
//  Created by Sang on 4/9/20.
//  Copyright © 2020 nxsang063@gmail.com. All rights reserved.
//

import UIKit

enum DefaultCellType {
    case PASS_CODE
    case CLEAR_HISTORY
}

protocol DefaultCellDelegate: class {
    func selectedCellDefault(type: DefaultCellType)
}
class DefaultCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgNext: UIImageView!
    weak var delegate: DefaultCellDelegate?
    
    var type: DefaultCellType! {
        didSet {
            switch type {
            case .PASS_CODE:
                lblTitle.text = "Passcode Lock"
                imgNext.image = imgNext.image?.imageWithColor(.lightGray)
                break
            default:
                lblTitle.text = "Clear History and Website Data"
                lblTitle.textColor = .systemBlue
                break
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupCell(type: DefaultCellType = .PASS_CODE) {
        self.type = type
    }
    @IBAction func selectedCell(_ sender: Any) {
        self.delegate?.selectedCellDefault(type: self.type)
    }
}


extension UIImage {
    func imageWithColor(_ tintColor: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        
        let context = UIGraphicsGetCurrentContext()! as CGContext
        context.translateBy(x: 0, y: self.size.height)
        context.scaleBy(x: 1.0, y: -1.0);
        context.setBlendMode(CGBlendMode.normal)
        
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height) as CGRect
        context.clip(to: rect, mask: self.cgImage!)
        tintColor.setFill()
        context.fill(rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()! as UIImage
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
