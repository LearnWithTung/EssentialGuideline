//
//  FeedPresenter.swift
//  MVP
//
//  Created by Tung Vu Duc on 07/01/2021.
//

import Foundation
import EssentialFeature

protocol FeedLoadView {
    func display(_ feed: [FeedItem])
}

protocol FeedLoadingView {
    func display(_ isLoading: Bool)
}

public class FeedPresenter {
    private let feedLoader: FeedLoader

    public init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }
    
    var feedView: FeedLoadView?
    var loadingView: FeedLoadingView?
    
    func didStartReloadFeed() {
        load()
    }
    
    private func load() {
        loadingView?.display(true)
        feedLoader.load() {[weak self] result in
            if let feed = try? result.get() {
                self?.feedView?.display(feed)
            }

            self?.loadingView?.display(false)
        }
    }
}
