//
//  String+Extension.swift
//  BrowserApp
//
//  Created by admin on 25/11/2019.
//  Copyright © 2019 nxsang063@gmail.com. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    func verifyUrl() -> Bool {
        if let url = URL(string: self) {
            return UIApplication.shared.canOpenURL(url)
        }
        return false
    }
    
    func replacingOccurrences() -> String {
        return self.replacingOccurrences(of: " ", with: "+")
    }
    
    func isUrlFile() -> Bool {
        if self.contains(".pdf") || self.contains(".doc") || self.contains(".docx") || self.contains(".xls")
            || self.contains(".xlsx") || self.contains(".zip") || self.contains(".ppt") || self.contains(".pttx") || self.contains(".mp3") || self.contains(".wav") || self.contains(".rtf") || self.contains(".png") || self.contains(".jpg"){
            return true
        }
        return false
    }
}

extension Notification.Name {
    
    static let beginDownload = Notification.Name(
       rawValue: "beginDownload")
    
    static let isUrlFile = Notification.Name(
    rawValue: "isUrlFile")
}

extension UIApplication {
    
    static var rootVC: UINavigationController? {
        return UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
    }
    
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        
        return controller
    }
}

