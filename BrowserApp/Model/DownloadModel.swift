//
//  DownloadModel.swift
//  BrowserApp
//
//  Created by admin on 25/11/2019.
//  Copyright © 2019 nxsang063@gmail.com. All rights reserved.
//

import Foundation
import UIKit

class DownloadModel {
    var urlStr: String = ""
    var name: String = ""
    var progress: CGFloat = 0
    var indexPath: IndexPath!
    var type: TypeFolder! = .none
    init(urlStr: String, name: String, progress: CGFloat, indexP: IndexPath) {
        self.name = name
        self.progress = progress
        self.urlStr = urlStr
        self.indexPath = indexP
    }
}

