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
        loader?.load() {[weak self] _ in
            self?.refreshControl?.endRefreshing()
        }
    }
    
}
