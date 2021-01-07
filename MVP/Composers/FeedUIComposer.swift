//
//  FeedUIComposer.swift
//  EssentialGuidelineiOS
//
//  Created by Tung Vu Duc on 06/01/2021.
//

import Foundation
import EssentialFeature
import UIKit

public final class FeedUIComposer {
    private init() {}
    
    public static func composeWith(feedLoader: FeedLoader, imageLoader: FeedImageDataLoader) -> FeedViewController {
        let viewModel = FeedRefreshViewModel(feedLoader: feedLoader)
        let refreshController = FeedRefreshController(viewModel: viewModel)
        let feedController =  FeedViewController(refreshController: refreshController)
        viewModel.onFeedLoad = { [weak feedController] feed in
            feedController?.tableModel = feed.map {
                FeedCellController(viewModel: FeedCellViewModel(imageDataLoader: imageLoader, model: $0, imageTransformer: UIImage.init))
            }
        }
        return feedController
    }

}
