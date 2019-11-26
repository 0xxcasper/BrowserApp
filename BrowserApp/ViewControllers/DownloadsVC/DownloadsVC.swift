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

    private let searchController = UISearchController(searchResultsController: nil)
    
    private lazy var addBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addDidClick))
    }()
    private lazy var editBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editDidClick))
    }()
    
    private var documentInteractionController: UIDocumentInteractionController?
    private var downloadTasks = [URLSessionDownloadTask]()
    private var backgroundSession: URLSession?
    
    private var downloads = [DownloadModel]()
    private var downloadings = [DownloadModel]()
    private var downloadSearchs = [DownloadModel]()
    private var isPause = false
    private var isSearch = false
    
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
        
        setUpSearchBar()
        setUpView()
        setUpTableView()
        showAllDocument()
    }
}

// MARK: - Action's Method

private extension DownloadsVC {
    
    @objc func addDidClick() {
        let alert = UIAlertController(title: "Download URL", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "https://example.com"
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancelAction)
        
        let downloadAction = UIAlertAction(title: "Download", style: .default) { (UIAlertAction) in
            let textField = alert.textFields![0]
            
            guard let text = textField.text, text.isUrlFile(), let url = URL(string: text) else { return }
            self.downloadFile(documentUrl: url)
        }
        alert.addAction(downloadAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func editDidClick() {
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let pauseAction = UIAlertAction(title: !isPause ? "Pause All" : "Resume All", style: .default) { (UIAlertAction) in
            !self.isPause ? self.pauseAllTask() : self.resumeAllTask()
        }
        let deleteAction = UIAlertAction(title: "Delete All", style: UIAlertAction.Style.destructive) {
            (UIAlertAction) in
            FileManagerHelper.removeAllDocument()
            self.downloads.removeAll()
            self.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        optionMenu.addAction(pauseAction)
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    @objc func beginDownload(notification: Notification) {
        if let urlStr = notification.userInfo?["url"] as? String, let url = URL(string: urlStr) {
            downloadFile(documentUrl: url)
        }
    }
}

// MARK: - Private's Method

private extension DownloadsVC {
    
    func setUpView() {
        navigationItem.title = "Download"
        navigationItem.leftBarButtonItem = addBarButtonItem
        navigationItem.rightBarButtonItem = editBarButtonItem
        navigationItem.hidesSearchBarWhenScrolling = false

        let cancelButtonAttributes = [NSAttributedString.Key.foregroundColor: self.view.tintColor]
        UIBarButtonItem.appearance().setTitleTextAttributes(cancelButtonAttributes as [NSAttributedString.Key : Any] , for: .normal)
    }
    
    func setUpTableView() {
        tbvDownload.registerXibFile(DownloadTableViewCell.self)
        tbvDownload.rowHeight = 45
        tbvDownload.dataSource = self
        tbvDownload.delegate = self
    }
    
    func setUpSearchBar() {
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.searchBar.placeholder = "Search downloads"
        self.searchController.searchBar.delegate = self
        self.definesPresentationContext = false
        self.searchController.searchBar.searchTextField.tintColor = self.view.tintColor

        self.navigationItem.searchController = searchController
    }
    
    func showAllDocument() {
        downloads.removeAll()
        for (index, content) in FileManagerHelper.getAllDocument().enumerated() {
            downloads.append(DownloadModel( urlStr: content.absoluteString, name: content.lastPathComponent, progress: 100, indexP: IndexPath(row: index, section: 1)))
        }
        self.reloadData()
    }
    
    func reloadData() {
        if tbvDownload != nil {
            DispatchQueue.main.async {
                self.tbvDownload.reloadData()
            }
        }
    }
    
    func downloadFile(documentUrl: URL) {
        downloadings.append(DownloadModel(urlStr: documentUrl.absoluteString, name: documentUrl.lastPathComponent, progress: 0, indexP: IndexPath(row: downloadings.count, section: 0)))
        self.reloadData()
        
        let backgroundSessionConfiguration = URLSessionConfiguration.background(withIdentifier: "backgroundSession")
        backgroundSession = Foundation.URLSession(configuration: backgroundSessionConfiguration, delegate: self,
                                                  delegateQueue: OperationQueue.main)
        let request = URLRequest(url: documentUrl)
        
        if let downloadTask = backgroundSession?.downloadTask(with: request) {
            downloadTasks.append(downloadTask)
            if !isPause { downloadTask.resume() }
        }
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
    
    func pauseAllTask() {
        isPause = true
        downloadTasks.forEach({ (downloadTask) in
            downloadTask.suspend()
        })
    }
    
    func resumeAllTask() {
        isPause = false
        downloadTasks.forEach({ (downloadTask) in
            downloadTask.resume()
        })
    }
    
    func filterFunction(searchText: String) {
        downloadSearchs = downloads.filter({ $0.name.contains(searchText)})
        isSearch = true
        tbvDownload.reloadData()
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
        self.showAllDocument()
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
        return section == 0 ? downloadings.count : (isSearch ? downloadSearchs.count : downloads.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(DownloadTableViewCell.self, for: indexPath)
        cell.setDataCell(down: indexPath.section == 0 ? downloadings[indexPath.row] :
            (isSearch ? downloadSearchs[indexPath.row] : downloads[indexPath.row]))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1, let url = URL(string: isSearch ? downloadSearchs[indexPath.row].urlStr : downloads[indexPath.row].urlStr) {
            self.openDocument(fileUrl: url)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) && indexPath.section == 1  {
            guard let url = URL(string: isSearch ? downloadSearchs[indexPath.row].urlStr : downloads[indexPath.row].urlStr) else { return }
            self.tbvDownload.beginUpdates()
            FileManagerHelper.removeDocument(fileUrl: url)
            if self.isSearch {
                downloadSearchs.remove(at: indexPath.row)
            } else {
                downloads.remove(at: indexPath.row)
            }
            self.tbvDownload.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            self.tbvDownload.endUpdates()
        }
    }
}

//MARK: - UISearchBarDelegate's Method

extension DownloadsVC: UISearchBarDelegate
{
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isSearch = true
        tbvDownload.reloadData()
        searchBar.setShowsCancelButton(true, animated: true)
        searchBar.tintColor = .white
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.filterFunction(searchText: searchText)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)    {
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
        guard let term = searchBar.text, term.isEmpty == false else { return }

        self.filterFunction(searchText: term)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.text = String()
        searchBar.resignFirstResponder()
        isSearch = false
        showAllDocument()
    }
}
