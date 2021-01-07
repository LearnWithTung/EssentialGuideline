//
//  FeedPresenter.swift
//  MVP
//
//  Created by Tung Vu Duc on 07/01/2021.
//

import Foundation
import EssentialFeature

struct FeedLoadViewModel {
    let feed: [FeedItem]
}

protocol FeedLoadView {
    func display(_ viewModel: FeedLoadViewModel)
}

struct FeedLoadingModel {
    let isLoading: Bool
}

protocol FeedLoadingView {
    func display(_ viewModel: FeedLoadingModel)
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
        loadingView?.display(.init(isLoading: true))
        feedLoader.load() {[weak self] result in
            if let feed = try? result.get() {
                self?.feedView?.display(.init(feed: feed))
            }

            self?.loadingView?.display(.init(isLoading: false))
        }
    }
}
