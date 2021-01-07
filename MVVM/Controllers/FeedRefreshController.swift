//
//  FeedRefreshController.swift
//  MVC
//
//  Created by Tung Vu Duc on 07/01/2021.
//

import UIKit
import EssentialFeature

class FeedRefreshViewModel {
    
    typealias Observer<T> = (T) -> Void

    private let feedLoader: FeedLoader

    public init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }
    
    var onFeedLoadState: Observer<Bool>?
    var onFeedLoad: Observer<[FeedItem]>?
    
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
    
    lazy var view = binded(UIRefreshControl())
    
    private let viewModel: FeedRefreshViewModel
    
    public init(feedLoader: FeedLoader) {
        self.viewModel = FeedRefreshViewModel(feedLoader: feedLoader)
    }
    
    var onFeedLoad: (([FeedItem]) -> Void)?

    @objc func refresh() {
        viewModel.load()
    }
    
    private func binded(_ view: UIRefreshControl) -> UIRefreshControl {
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
        
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return view
    }
}
