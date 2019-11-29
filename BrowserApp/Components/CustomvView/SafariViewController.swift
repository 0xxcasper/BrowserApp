//
//  SafariViewController.swift
//  BrowserApp
//
//  Created by admin on 25/11/2019.
//  Copyright © 2019 nxsang063@gmail.com. All rights reserved.
//

import Foundation
import UIKit
import WebKit
import RealmSwift

class SafariViewController: UIViewController {
    private var history: Results<HistoryModel>?

    var url: URL? {
        didSet {
            if let url = url { load(url) }
        }
    }
    var tintColor: UIColor? = .blue
    
    private var tabs = [WKWebView]()
    private var isNewTab = false
    private var webView: WKWebView?
    private var progressView: UIProgressView?
    private let estimatedProgressKeyPath = "estimatedProgress"
    
    private var tableView: UITableView = {
        let tbView = UITableView(frame: .zero, style: UITableView.Style.plain)
        tbView.backgroundColor = .lightGray
        tbView.registerXibFile(NewTabTableViewCell.self)
        return tbView
    }()

    private lazy var searchBars:UISearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: AppConstant.SREEEN_WIDTH - 100, height: 18))

    private lazy var backBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(backDidClick))
    }()
    
    private lazy var cancelBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(cancelDidClick))
    }()
    
    private lazy var forwardBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(image: UIImage(named: "forward"), style: .plain, target: self, action: #selector(forwardDidClick))
    }()
    
    private lazy var reloadBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(reloadDidClick))
    }()
    
    private lazy var stopBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(stopDidClick))
    }()
    
    private lazy var activityBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(activityDidClick))
    }()
    
    private lazy var historyBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(historyDidClick))
    }()
    
    private lazy var flexibleSpaceBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    }()
    
    private lazy var newTabBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(newTabDidClick))
    }()
    
    private lazy var addButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addDidClick))
    }()
    
    private lazy var closeButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(title: "Close All", style: UIBarButtonItem.Style.plain, target: self, action: #selector(closeDidClick))
    }()
    
    private lazy var doneButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(newTabDidClick))
    }()
    
    public convenience init( url: URL, tintColor: UIColor = .blue) {
        self.init()
        self.url = url
        self.tintColor = tintColor
    }
    
    deinit {
        guard let webView = webView else { return }
        webView.removeObserver(self, forKeyPath: estimatedProgressKeyPath)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpWebView()
        setUpProgressView()
        setUpBarButtonItems()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpStateAndColor()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard let progressView = progressView else { return }
        progressView.removeFromSuperview()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        switch keyPath {
        case estimatedProgressKeyPath:
            guard let webView = webView else { return }
            guard let progressView = progressView else { return }
            let estimatedProgress = webView.estimatedProgress

            progressView.alpha = 1
            progressView.setProgress(Float(estimatedProgress), animated: true)
            
            if estimatedProgress >= 1.0 {
                UIView.animate(withDuration: 0.3, delay: 0.2, options: .curveEaseOut, animations: {
                    progressView.alpha = 0
                }, completion: { finished in
                    progressView.setProgress(0, animated: false)
                })
            }
        default:
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
}

// MARK: - SetUpViews's Methods

private extension SafariViewController {
    
    func setUpWebView() {
        searchBars.placeholder = "Search or enter website name"
        searchBars.delegate = self
        
        addNewTab()
    }
    
    func setUpProgressView() {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.trackTintColor = UIColor(white: 1, alpha: 0)
        self.progressView = progressView
        guard let navigationController = navigationController else { return }
        progressView.frame = CGRect(x: 0, y: navigationController.navigationBar.frame.size.height - progressView.frame.size.height, width: navigationController.navigationBar.frame.size.width, height: progressView.frame.size.height)
    }
    
    func setUpBarButtonItems() {
        setSearchBar()
        setToolBarItems()
        
        backBarButtonItem.isEnabled = false
        forwardBarButtonItem.isEnabled = false
    }
    
    func setUpStateAndColor() {
        guard let navigationController = navigationController else { return }
        navigationController.setNavigationBarHidden(false, animated: true)
        navigationController.setToolbarHidden(false, animated: false)
        navigationController.toolbar.tintColor = .blue

        navigationController.toolbar.isTranslucent = false
        navigationController.toolbar.barTintColor = .white
        
        if let progressView = progressView {
            progressView.progressTintColor = .blue
            navigationController.navigationBar.addSubview(progressView)
        }
    }
    
    func setSearchBar() {
        navigationItem.title = nil
        let leftNavBarButton = UIBarButtonItem(customView: searchBars)
        navigationItem.leftBarButtonItem = leftNavBarButton
        navigationItem.rightBarButtonItem = reloadBarButtonItem
    }
    
    func setTitleBar() {
        navigationItem.leftBarButtonItem = nil
        navigationItem.rightBarButtonItem = nil
        navigationItem.title = "New Tab"
    }
    
    func setToolBarItems() {
        let toolBarItems = [backBarButtonItem, flexibleSpaceBarButtonItem ,forwardBarButtonItem, flexibleSpaceBarButtonItem, flexibleSpaceBarButtonItem, flexibleSpaceBarButtonItem ,flexibleSpaceBarButtonItem, historyBarButtonItem, flexibleSpaceBarButtonItem ,activityBarButtonItem, flexibleSpaceBarButtonItem, newTabBarButtonItem]
        
        setToolbarItems(toolBarItems, animated: true)
    }
    
    func setNewTabToolBarItems() {
        let toolBarItems = [closeButtonItem,flexibleSpaceBarButtonItem, addButtonItem, flexibleSpaceBarButtonItem ,doneButtonItem]
        
        setToolbarItems(toolBarItems, animated: true)
    }
    
    func addTableView() {
        view.addSubview(tableView)
        tableView.centerSuperview()
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func removeTableView() {
        tableView.removeFromSuperview()
    }
    
    func addNewTab() {
        self.searchBars.text = ""
        self.searchBars.endEditing(true)
        
        let webConfiguration = WKWebViewConfiguration()
        let webView = WKWebView(frame: CGRect(x: 0, y: 0, width: AppConstant.SREEEN_WIDTH, height: AppConstant.SCREEN_HEIGHT - AppConstant.STATUS_BAR_TOP - AppConstant.STATUS_BAR_BOTTOM - AppConstant.TOOL_BAR_HEIGHT), configuration: webConfiguration)
        
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        webView.isMultipleTouchEnabled = true
        
        webView.addObserver(self, forKeyPath: estimatedProgressKeyPath, options: .new, context: nil)
        tabs.append(webView)
        
        self.webView = webView
        view.addSubview(self.webView!)
        
        self.url = URL(string: "https://www.google.com")
    }
}

// MARK: - Support's Methods

private extension SafariViewController {
    
    func load(_ url: URL) {
        guard let webView = webView else { return }
        DispatchQueue.main.async {
            webView.load(URLRequest(url: url))
        }
    }
    
    func updateStateBarButtonItems() {
        guard let webView = webView else { return }
        backBarButtonItem.isEnabled = webView.canGoBack
        forwardBarButtonItem.isEnabled = webView.canGoForward
        
        if navigationItem.rightBarButtonItem != cancelBarButtonItem {
            navigationItem.rightBarButtonItem = webView.isLoading ? self.stopBarButtonItem : self.reloadBarButtonItem
        }
    }
}

// MARK: - Action's method

@objc extension SafariViewController {
    
    func backDidClick() {
        guard let webView = webView else { return }
        webView.goBack()
    }
    
    func forwardDidClick() {
        guard let webView = webView else { return }
        webView.goForward()
    }
    
    func reloadDidClick() {
        guard let webView = webView else { return }
        webView.stopLoading()
        if webView.url != nil {
            webView.reload()
        } else if let url = url {
            load(url)
        }
    }
    
    func stopDidClick() {
        guard let webView = webView else { return }
        webView.stopLoading()
    }
    
    func activityDidClick() {
        guard let url = url else { return }
        let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
    }
    
    func cancelDidClick() {
        searchBars.endEditing(true)
        guard let webView = webView else { return }
        navigationItem.rightBarButtonItem = webView.isLoading ? self.stopBarButtonItem : self.reloadBarButtonItem
    }
    
    func historyDidClick() {
        
    }
    
    func newTabDidClick() {
        if isNewTab {
            setToolBarItems()
            setSearchBar()
            removeTableView()
            isNewTab = false
        } else {
            setNewTabToolBarItems()
            setTitleBar()
            addTableView()
            tableView.reloadData()
            isNewTab = true
        }
    }
    
    func closeDidClick() {
        tabs.removeAll()
        addNewTab()
    }
    
    func addDidClick() {
        self.addNewTab()
        self.setToolBarItems()
        self.setSearchBar()
        self.isNewTab = false
    }
}

// MARK: - SafariViewController's Method

extension SafariViewController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        navigationItem.rightBarButtonItem = self.cancelBarButtonItem
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        guard let webView = webView else { return }
        navigationItem.rightBarButtonItem = webView.isLoading ? self.stopBarButtonItem : self.reloadBarButtonItem
    }
}

// MARK: - WKNavigationDelegate's Method

extension SafariViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        guard let url = webView.url else { return }
        searchBars.text = url.absoluteString
        if url.lastPathComponent.isUrlFile() {
            NotificationCenter.default.post(name: Notification.Name.isUrlFile, object: nil, userInfo: ["url": url.absoluteString, "name": url.lastPathComponent])
        }
        updateStateBarButtonItems()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        guard let url = webView.url else { return }
        let _ = HistoryModel.add(url: url.absoluteString, name: webView.title ?? " ", time: Date())
        updateStateBarButtonItems()
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        updateStateBarButtonItems()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        updateStateBarButtonItems()
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(WKNavigationActionPolicy(rawValue: WKNavigationActionPolicy.allow.rawValue + 2)!)
    }
}

// MARK: - UITableViewDataSource's Method

extension SafariViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tabs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(NewTabTableViewCell.self, for: indexPath)
        cell.lblTitle.text = tabs[indexPath.row].title == "" ? "New Tab" : tabs[indexPath.row].title
        cell.lblTitle.textColor = tabs[indexPath.row] == self.webView ? .blue : .black
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        setToolBarItems()
        setSearchBar()
        removeTableView()
        isNewTab = false
        
        self.webView = tabs[indexPath.row]
        view.addSubview(self.webView!)
        updateStateBarButtonItems()
    }
}

// MARK: - NewTabTableViewCellDelegate's Method

extension SafariViewController: NewTabTableViewCellDelegate
{
    func removeTab(indexP: IndexPath) {
        tabs.remove(at: indexP.row)
        tableView.reloadData()
        if tabs.count == 0 {
            addNewTab()
        }
    }
}
