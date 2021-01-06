//
//  FeedViewController.swift
//  EssentialGuidelineiOS
//
//  Created by Tung Vu Duc on 06/01/2021.
//

import UIKit
import EssentialFeature

public protocol FeedImageDataLoader {
    func loadImageData(from url: URL)
}

final public class FeedViewController: UITableViewController {
    
    private var feedLoader: FeedLoader?
    private var imageLoader: FeedImageDataLoader?
    private var tableModel = [FeedItem]() {
        didSet {
            tableView.reloadData()
        }
    }
        
    public convenience init(feedLoader: FeedLoader, imageLoader: FeedImageDataLoader) {
        self.init()
        
        self.feedLoader = feedLoader
        self.imageLoader = imageLoader
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(load), for: .valueChanged)
        load()
    }
    
    @objc func load() {
        refreshControl?.beginRefreshing()
        feedLoader?.load() {[weak self] result in
            if let feed = try? result.get() {
                self?.tableModel = feed
            }
            self?.refreshControl?.endRefreshing()
        }
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableModel.count
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellModel = tableModel[indexPath.row]
        let cell = FeedUserCell()
        cell.emailLabel.text = cellModel.email
        cell.firstNameLabel.text = cellModel.firstName
        cell.lastNameLabel.text = cellModel.lastName
        imageLoader?.loadImageData(from: cellModel.url)
        return cell
    }
}
