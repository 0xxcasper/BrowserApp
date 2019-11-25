//
//  DownloadsVC.swift
//  BrowserApp
//
//  Created by SangNX on 11/24/19.
//  Copyright © 2019 nxsang063@gmail.com. All rights reserved.
//

import UIKit

class DownloadsVC: UIViewController {
    
    @IBOutlet weak var tbvDownload: UITableView!
    
    var documentInteractionController: UIDocumentInteractionController?
    var downloadTask: URLSessionDownloadTask?
    var backgroundSession: URLSession?
    
    private var downloads = [DownloadModel]()
    private var downloadings = [DownloadModel]()

    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name.beginDownload, object: nil)
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.beginDownload(notification:)), name: Notification.Name.beginDownload, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showAllFileSaved()
    }

    @objc func beginDownload(notification: Notification) {
        if let urlStr = notification.userInfo?["url"] as? String, let url = URL(string: urlStr) {
            downloadFile(documentUrl: url)
        }
    }
}

// MARK: - Private's Method

private extension DownloadsVC {
    
    func downloadFile(documentUrl: URL) {
        downloadings.append(DownloadModel(urlStr: documentUrl.absoluteString, name: documentUrl.lastPathComponent, progress: 0, indexP: IndexPath(row: downloadings.count, section: 0)))
        self.reloadData()
        
        let backgroundSessionConfiguration = URLSessionConfiguration.background(withIdentifier: "backgroundSession")
        backgroundSession = Foundation.URLSession(configuration: backgroundSessionConfiguration, delegate: self,
                                                  delegateQueue: OperationQueue.main)
        let request = URLRequest(url: documentUrl)
        downloadTask = backgroundSession?.downloadTask(with: request)
        downloadTask?.resume()
    }
    
    func openDocument(fileUrl: URL) {
        documentInteractionController = UIDocumentInteractionController(url: fileUrl)
        documentInteractionController?.delegate = self
        documentInteractionController?.presentPreview(animated: true)
    }
    
    func getDestinationFileUrl(response: URLResponse) -> URL {
        var docsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let filename = response.suggestedFilename ?? "file.pdf"
        docsURL.appendPathComponent(filename)
        return docsURL
    }
    
    func setUpTableView() {
        tbvDownload.registerXibFile(DownloadTableViewCell.self)
        tbvDownload.rowHeight = 42
        tbvDownload.dataSource = self
        tbvDownload.delegate = self
    }
    
    func showAllFileSaved() {
        downloads.removeAll()
        for (index, content) in FileManagerHelper.getAllDocument().enumerated() {
            downloads.append(DownloadModel( urlStr: content.absoluteString, name: content.lastPathComponent, progress: 100, indexP: IndexPath(row: index, section: 1)))
        }
        self.reloadData()
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.tbvDownload.reloadData()
        }
    }
}

// MARK: - URLSessionDownloadDelegate's Method

extension DownloadsVC: URLSessionDownloadDelegate {

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
    
        guard let response = downloadTask.response else { return }
        let progress = CGFloat(totalBytesWritten) / CGFloat(totalBytesExpectedToWrite)
        
        for (index, down) in downloadings.enumerated() where down.urlStr == response.url?.absoluteString {
            downloadings[index].progress = progress
        }
        self.reloadData()
    }

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard let response = downloadTask.response else { return }
        
        for (index, down) in downloadings.enumerated() where down.urlStr == response.url?.absoluteString {
            downloadings.remove(at: index)
        }
        let destinationURL = getDestinationFileUrl(response: response)

        FileManagerHelper.removeDocument(fileUrl: destinationURL)
        FileManagerHelper.addDocument(fileUrl: destinationURL, location: location)
        self.showAllFileSaved()
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {

    }
}

// MARK: - UIDocumentInteractionControllerDelegate's Method

extension DownloadsVC: UIDocumentInteractionControllerDelegate {

    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
}

// MARK: - UITableViewDataSource's Method

extension DownloadsVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? downloadings.count : downloads.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(DownloadTableViewCell.self, for: indexPath)
        cell.setDataCell(down: indexPath.section == 0 ? downloadings[indexPath.row] : downloads[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1, let url = URL(string: downloads[indexPath.row].urlStr) {
            self.openDocument(fileUrl: url)
        }
    }
}
