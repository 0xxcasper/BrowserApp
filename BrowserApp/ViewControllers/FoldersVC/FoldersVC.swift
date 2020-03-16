//
//  FoldersVC.swift
//  BrowserApp
//
//  Created by SangNX on 11/24/19.
//  Copyright © 2019 nxsang063@gmail.com. All rights reserved.
//

import UIKit
import Files
import AudioToolbox

class FoldersVC: BaseViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var folderList: [DownloadModel] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    private var documentInteractionController: UIDocumentInteractionController?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(nibWithCellClass: FolderCell.self)
        
        self.addLeftBarButton()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fetchData()
    }
    
    override func addDidClick() {
        let alert = UIAlertController(title: "Create New Folder", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "folder name"
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancelAction)
        
        let downloadAction = UIAlertAction(title: "Create", style: .default) { (UIAlertAction) in
            let textField = alert.textFields![0]

            guard let name = textField.text else { return }
            self.createFolder(name: name) {
                self.fetchData()
            }
        }
        alert.addAction(downloadAction)
        self.present(alert, animated: true, completion: nil)
    }


    func fetchData() {
        let urls = FileManager.default.urls(for: .documentDirectory) ?? []
        var arr: [DownloadModel] = []
        for (index, value) in urls.enumerated() {
            if(!value.lastPathComponent.contains("realm")) {
                arr.append(DownloadModel(urlStr: value.absoluteString, name: value.lastPathComponent, progress: 1000, indexP: IndexPath(row: index, section: 1)))
            }
        }
        folderList = arr
    }
    
    
    func createFolder(name: String, success: @escaping (()->Void)) {
        let DocumentDirectory = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
        let DirPath = DocumentDirectory.appendingPathComponent(name)
        do
        {
            try FileManager.default.createDirectory(atPath: DirPath!.path, withIntermediateDirectories: true, attributes: nil)
        }
        catch let error as NSError
        {
            print("Unable to create directory \(error.debugDescription)")
        }
        print("Dir Path = \(DirPath!)")
        success()
    }
}

extension FoldersVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return folderList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: FolderCell.self, for: indexPath)
        cell.setupCell(item: folderList[indexPath.row])
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width/4, height: collectionView.bounds.width/4 + 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    func openDocument(fileUrl: URL) {
        documentInteractionController = UIDocumentInteractionController(url: fileUrl)
        documentInteractionController?.delegate = self
        documentInteractionController?.presentPreview(animated: true)
    }

}

extension FoldersVC: UIDocumentInteractionControllerDelegate {
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
}

extension FoldersVC: FolderCellDelegate {
    func longPressCell(item: DownloadModel) {
        let settingsActionSheet: UIAlertController = UIAlertController(title:nil, message:nil, preferredStyle:UIAlertController.Style.actionSheet)
        settingsActionSheet.addAction(UIAlertAction(title:"Move", style:UIAlertAction.Style.default, handler:{ action in
            
        }))
         
        settingsActionSheet.addAction(UIAlertAction(title:"Delete", style:UIAlertAction.Style.destructive, handler:{ action in
         
        }))
         
        settingsActionSheet.addAction(UIAlertAction(title:"Cancel", style:UIAlertAction.Style.cancel, handler:nil))
        present(settingsActionSheet, animated:true, completion:nil)
    }
    
    func singleTapCell(item: DownloadModel) {
        if(item.type == TypeFolder.Document) {
            openDocument(fileUrl: URL(string: item.urlStr)!)
            return
        }
        let vc = FolderView()
        vc.item = item
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension FileManager {
    func urls(for directory: FileManager.SearchPathDirectory, skipsHiddenFiles: Bool = true ) -> [URL]? {
        let documentsURL = urls(for: directory, in: .userDomainMask)[0]
        print("documentsURL \(documentsURL)")
        let fileURLs = try? contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil, options: skipsHiddenFiles ? .skipsHiddenFiles : [] )
        return fileURLs
    }
}

extension String {

    func fileName() -> String {
        return URL(fileURLWithPath: self).deletingPathExtension().lastPathComponent
    }

    func fileExtension() -> String {
        return URL(fileURLWithPath: self).pathExtension
    }
}
