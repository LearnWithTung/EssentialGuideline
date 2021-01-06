//
//  FeedViewController.swift
//  EssentialGuidelineiOS
//
//  Created by Tung Vu Duc on 06/01/2021.
//

import UIKit
import EssentialFeature

final public class FeedViewController: UITableViewController {
    
    private var loader: FeedLoader?
    private var tableModel = [FeedItem]() {
        didSet {
            tableView.reloadData()
        }
    }
        
    public convenience init(loader: FeedLoader) {
        self.init()
        
        self.loader = loader
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(load), for: .valueChanged)
        load()
    }
    
    @objc func load() {
        refreshControl?.beginRefreshing()
        loader?.load() {[weak self] result in
            self?.tableModel = (try? result.get()) ?? []
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
        return cell
    }
}
