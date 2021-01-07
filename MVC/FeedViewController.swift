//
//  FeedViewController.swift
//  EssentialGuidelineiOS
//
//  Created by Tung Vu Duc on 06/01/2021.
//

import UIKit
import EssentialFeature

final public class FeedViewController: UITableViewController {
    
    private var feedLoader: FeedLoader?
    private var imageLoader: FeedImageDataLoader?
    private var tableModel = [FeedItem]() {
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
        
    public convenience init(feedLoader: FeedLoader, imageLoader: FeedImageDataLoader) {
        self.init()
        
        self.feedLoader = feedLoader
        self.imageLoader = imageLoader
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = .white
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(load), for: .valueChanged)
        
        tableView.register(UINib(nibName: "FeedUserCell",
                                 bundle: Bundle(for: FeedUserCell.self)),
                           forCellReuseIdentifier: "FeedUserCell")
        load()
    }
    
    @objc func load() {
        refreshControl?.beginRefreshing()
        feedLoader?.load() {[weak self] result in
            if let feed = try? result.get() {
                self?.tableModel = feed
            }
            
            if Thread.isMainThread {
                self?.refreshControl?.endRefreshing()
            } else {
                DispatchQueue.main.async {
                    self?.refreshControl?.endRefreshing()
                }
            }
        }
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
