//
//  FeedViewController.swift
//  EssentialGuidelineiOS
//
//  Created by Tung Vu Duc on 06/01/2021.
//

import UIKit
import EssentialFeature

public final class FeedRefreshController: NSObject {
    
    lazy var view: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return refreshControl
    }()
    
    private let feedLoader: FeedLoader
    
    public init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }
    
    var onFeedLoad: (([FeedItem]) -> Void)?

    @objc func refresh() {
        view.beginRefreshing()
        feedLoader.load() {[weak self] result in
            if let feed = try? result.get() {
                self?.onFeedLoad?(feed)
            }
            
            if Thread.isMainThread {
                self?.view.endRefreshing()
            } else {
                DispatchQueue.main.async {
                    self?.view.endRefreshing()
                }
            }
        }
    }
}

final public class FeedViewController: UITableViewController {
    
    private var refreshController: FeedRefreshController?
    private var imageLoader: FeedImageDataLoader?
    var tableModel = [FeedItem]() {
        didSet {
            if Thread.isMainThread {
                self.tableView.reloadData()
            } else {
                DispatchQueue.main.async { [weak self] in
                    self?.tableView.reloadData()
                }
            }
        }
    }
        
    public convenience init(refreshController: FeedRefreshController, imageLoader: FeedImageDataLoader) {
        self.init()
        self.refreshController = refreshController
        self.imageLoader = imageLoader
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        tableView.backgroundColor = .white
        
        tableView.register(UINib(nibName: "FeedUserCell",
                                 bundle: Bundle(for: FeedUserCell.self)),
                           forCellReuseIdentifier: "FeedUserCell")
        
        refreshControl = refreshController?.view
        refreshController?.refresh()
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableModel.count
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellModel = tableModel[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedUserCell", for: indexPath) as! FeedUserCell
        cell.emailLabel.text = cellModel.email
        cell.firstNameLabel.text = cellModel.firstName
        cell.lastNameLabel.text = cellModel.lastName
        cell.userImageView.image = nil
        imageLoader?.loadImageData(from: cellModel.url) { result in
            let data = try? result.get()
            cell.userImageView.image = data.map(UIImage.init) ?? nil
        }
        return cell
    }
}
