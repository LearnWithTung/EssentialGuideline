//
//  FeedRefreshController.swift
//  MVC
//
//  Created by Tung Vu Duc on 07/01/2021.
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
