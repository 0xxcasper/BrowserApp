//
//  FolderCell.swift
//  BrowserApp
//
//  Created by SangNX on 3/15/20.
//  Copyright © 2020 nxsang063@gmail.com. All rights reserved.
//

import UIKit
import AudioToolbox

enum TypeFile: String {
    case mp3        = "mp3"
    case mp4        = "mp4"
    case png        = "png"
    case jpg        = "jpg"
    case folder     = ""
    case doct       = "doct"
    case file       = "file"
}

enum TypeFolder {
    case Document
    case Folder
}

protocol FolderCellDelegate: class {
    func longPressCell(item: DownloadModel)
    func singleTapCell(item: DownloadModel)
}

class FolderCell: UICollectionViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var type: TypeFolder! = .none
    var item: DownloadModel! = nil
    weak var delegate: FolderCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let singleTapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(singleTapView))
         singleTapGesture.numberOfTapsRequired = 1
        self.addGestureRecognizer(singleTapGesture)

        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressView))
        longPressRecognizer.minimumPressDuration = 1.0
        self.addGestureRecognizer(longPressRecognizer)
    }
    
    func setupCell(item: DownloadModel) {
        lblName.text = item.name
        switch item.name.fileExtension() {
        case TypeFile.mp3.rawValue, TypeFile.mp4.rawValue:
            imageView.image = #imageLiteral(resourceName: "mp3.png")
            type = .Document
            break
        case TypeFile.png.rawValue, TypeFile.jpg.rawValue:
            imageView.image = #imageLiteral(resourceName: "image")
            type = .Document
            break
        case TypeFile.folder.rawValue:
            imageView.image = #imageLiteral(resourceName: "folder")
            type = .Folder
            break
        default:
            imageView.image = #imageLiteral(resourceName: "doct")
            type = .Document
        }
        
        item.type = type
        self.item = item
    }

    @objc func longPressView(gesture: UITapGestureRecognizer) {
        delegate?.longPressCell(item: self.item)
        AudioServicesPlaySystemSound(1519)
    }
    
    @objc func singleTapView(gesture: UITapGestureRecognizer) {
        delegate?.singleTapCell(item: self.item)
        AudioServicesPlaySystemSound(1519)
    }

}
