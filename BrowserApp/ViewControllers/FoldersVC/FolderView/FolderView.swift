//
//  FolderView.swift
//  BrowserApp
//
//  Created by SangNX on 3/16/20.
//  Copyright © 2020 nxsang063@gmail.com. All rights reserved.
//

import UIKit
import Files

class FolderView: BaseViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    private var documentInteractionController: UIDocumentInteractionController?

    var item: DownloadModel! = nil
    var folderList: [DownloadModel] = [] {
        didSet {
            collectionView.reloadData()
        }
    }

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
    
    func fetchData() {
        let url = URL(fileURLWithPath: URL(string: item.urlStr)!.path)
        var arr: [DownloadModel] = []

        if let enumerator = FileManager.default.enumerator(at: url, includingPropertiesForKeys: [.isRegularFileKey], options: [.skipsHiddenFiles, .skipsPackageDescendants]) {
            for case let fileURL as URL in enumerator {
                arr.append(DownloadModel(urlStr: fileURL.absoluteString, name: fileURL.lastPathComponent, progress: 1000, indexP: IndexPath(row: 0, section: 1)))
            }
        }
        folderList = arr
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
            self.createFolder(name: name)
        }
        alert.addAction(downloadAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func createFolder(name: String) {
        let stringPath = item.urlStr + name
        let url = URL(string: stringPath)
        if !FileManager.default.fileExists(atPath: url!.path) {
              do {
                  try FileManager.default.createDirectory(atPath: url!.path, withIntermediateDirectories: false, attributes: nil)
              } catch let error {
                  print(error.localizedDescription)
                  return
              }
         }
        
    }
}

extension FolderView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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

extension FolderView: UIDocumentInteractionControllerDelegate {
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
}

extension FolderView: FolderCellDelegate {
    func longPressCell(item: DownloadModel) {
//        let settingsActionSheet: UIAlertController = UIAlertController(title:nil, message:nil, preferredStyle:UIAlertController.Style.actionSheet)
//        settingsActionSheet.addAction(UIAlertAction(title:"Move", style:UIAlertAction.Style.default, handler:{ action in
//
//        }))
//
//        settingsActionSheet.addAction(UIAlertAction(title:"Delete", style:UIAlertAction.Style.destructive, handler:{ action in
//
//        }))
//
//        settingsActionSheet.addAction(UIAlertAction(title:"Cancel", style:UIAlertAction.Style.cancel, handler:nil))
//        present(settingsActionSheet, animated:true, completion:nil)
    }
    
    func singleTapCell(item: DownloadModel) {
//        if(item.type == TypeFolder.Document) {
//            openDocument(fileUrl: URL(string: item.urlStr)!)
//            return
//        }
//        let vc = FolderView()
//        vc.item = item
//        self.navigationController?.pushViewController(vc, animated: true)
    }
}
