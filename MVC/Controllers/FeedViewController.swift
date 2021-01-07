//
//  FeedViewController.swift
//  EssentialGuidelineiOS
//
//  Created by Tung Vu Duc on 06/01/2021.
//

import UIKit
import EssentialFeature

class FeedCellController {
    
    private let imageDataLoader: FeedImageDataLoader
    private let model: FeedItem
    
    init(imageDataLoader: FeedImageDataLoader, model: FeedItem) {
        self.imageDataLoader = imageDataLoader
        self.model = model
    }
    
    func view(_ tableView: UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedUserCell") as! FeedUserCell
        cell.emailLabel.text = model.email
        cell.firstNameLabel.text = model.firstName
        cell.lastNameLabel.text = model.lastName
        cell.userImageView.image = nil
        imageDataLoader.loadImageData(from: model.url) { result in
            let data = try? result.get()
            cell.userImageView.image = data.map(UIImage.init) ?? nil
        }
        return cell
    }
    
}

final public class FeedViewController: UITableViewController {
    
    private var refreshController: FeedRefreshController?
    
    var tableModel = [FeedCellController]() {
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
        
    public convenience init(refreshController: FeedRefreshController) {
        self.init()
        self.refreshController = refreshController
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
        let cellController = tableModel[indexPath.row]
        return cellController.view(tableView)
    }
}
