//
//  FeedRefreshViewModel.swift
//  MVVM
//
//  Created by Tung Vu Duc on 07/01/2021.
//

import Foundation
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
