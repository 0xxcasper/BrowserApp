//
//  FolderCell.swift
//  BrowserApp
//
//  Created by SangNX on 3/15/20.
//  Copyright © 2020 nxsang063@gmail.com. All rights reserved.
//

import UIKit

enum TypeFile: String {
    case mp3        = "mp3"
    case mp4        = "mp4"
    case png        = "png"
    case jpg        = "jpg"
    case folder     = ""
    case doct       = "doct"
    case file       = "file"
}

class FolderCell: UICollectionViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    let type: TypeFile = .file
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupCell(item: DownloadModel) {
        lblName.text = item.name
        print("sang - \(item.name.fileExtension())")
        
        switch item.name.fileExtension() {
        case TypeFile.mp3.rawValue, TypeFile.mp3.rawValue:
            imageView.image = #imageLiteral(resourceName: "mp3.png")
        case TypeFile.png.rawValue, TypeFile.jpg.rawValue:
                imageView.image = #imageLiteral(resourceName: "image")
        case TypeFile.folder.rawValue:
                imageView.image = #imageLiteral(resourceName: "folder")
        default:
            imageView.image = #imageLiteral(resourceName: "doct")
        }
    }

}
