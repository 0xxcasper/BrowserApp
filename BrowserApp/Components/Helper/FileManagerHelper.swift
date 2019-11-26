//
//  FileManagerHelper.swift
//  BrowserApp
//
//  Created by admin on 25/11/2019.
//  Copyright © 2019 nxsang063@gmail.com. All rights reserved.
//

import Foundation

struct FileManagerHelper {
    
    static func removeDocument(fileUrl: URL ){
        let fileManager = FileManager.default
        do {
            if fileManager.fileExists(atPath: fileUrl.path) {
                try fileManager.removeItem(at: fileUrl)
            }
        } catch {
            print(error)
        }
    }
    
    static func addDocument(fileUrl: URL, location: URL){
        let fileManager = FileManager.default
        do {
            try fileManager.moveItem(at: location, to: fileUrl)
        } catch {
            print(error)
        }
    }
    
    static func getAllDocument() -> [URL] {
        if #available(iOS 10.0, *) {
            do {
                let docURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                let contents = try FileManager.default.contentsOfDirectory(at: docURL, includingPropertiesForKeys: [.fileResourceTypeKey], options: [.skipsHiddenFiles])
                let urls = contents.filter({ $0.lastPathComponent.isUrlFile() })
                return urls
            } catch {
                print("Could not locate file")
            }
        }
        return []
    }
    
    static func removeAllDocument() {
        if #available(iOS 10.0, *) {
            do {
                let docURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                let contents = try FileManager.default.contentsOfDirectory(at: docURL, includingPropertiesForKeys: [.fileResourceTypeKey], options: .skipsHiddenFiles)
                contents.forEach { (URL) in
                    FileManagerHelper.removeDocument(fileUrl: URL)
                }
            } catch {
                print("Could not locate file")
            }
        }
    }
}
