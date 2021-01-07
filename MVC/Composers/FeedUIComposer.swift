//
//  FeedUIComposer.swift
//  EssentialGuidelineiOS
//
//  Created by Tung Vu Duc on 06/01/2021.
//

import Foundation
import EssentialFeature

public final class FeedUIComposer {
    private init() {}
    
    public static func composeWith(feedLoader: FeedLoader, imageLoader: FeedImageDataLoader) -> FeedViewController {
        let refreshController = FeedRefreshController(feedLoader: feedLoader)
        let feedController =  FeedViewController(refreshController: refreshController)
        refreshController.onFeedLoad = { [weak feedController] feed in
            feedController?.tableModel = feed.map {FeedCellController(imageDataLoader: imageLoader, model: $0)}
        }
        return feedController
    }

}
