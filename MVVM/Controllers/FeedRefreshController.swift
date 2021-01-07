//
//  FeedRefreshController.swift
//  MVC
//
//  Created by Tung Vu Duc on 07/01/2021.
//

import UIKit
import EssentialFeature

class FeedRefreshViewModel {

    private let feedLoader: FeedLoader

    public init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }
    
    var onFeedLoadState: ((Bool) -> Void)?
    var onFeedLoad: (([FeedItem]) -> Void)?
    
    func load() {
        onFeedLoadState?(true)
        feedLoader.load() {[weak self] result in
            if let feed = try? result.get() {
                self?.onFeedLoad?(feed)
            }

            self?.onFeedLoadState?(false)
        }
    }
}

public final class FeedRefreshController: NSObject {
    
    lazy var view: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return refreshControl
    }()
    
    private let viewModel: FeedRefreshViewModel
    
    public init(feedLoader: FeedLoader) {
        self.viewModel = FeedRefreshViewModel(feedLoader: feedLoader)
    }
    
    var onFeedLoad: (([FeedItem]) -> Void)?

    @objc func refresh() {
        bind(viewModel)
        
        viewModel.load()
    }
    
    private func bind(_ viewModel: FeedRefreshViewModel) {
        viewModel.onFeedLoadState = { [weak self] isLoading in
            func refresh() {
                if isLoading {
                    self?.view.beginRefreshing()
                } else {
                    self?.view.endRefreshing()
                }
            }
            if Thread.isMainThread {
                refresh()
            } else {
                DispatchQueue.main.async {
                    refresh()
                }
            }
        }
        
        viewModel.onFeedLoad = { [weak self] feed in
            self?.onFeedLoad?(feed)
        }
    }
}
