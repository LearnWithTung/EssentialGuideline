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
        let presenter = FeedPresenter(feedLoader: feedLoader)
        let refreshController = FeedRefreshController(presenter: presenter)
        let feedController =  FeedViewController(refreshController: refreshController)
        presenter.loadingView = WeakRefVirtualProxy(refreshController)
        presenter.feedView = FeedViewApter(controller: feedController, imageLoader: imageLoader)
        return feedController
    }

}


final class WeakRefVirtualProxy<T: AnyObject> {
    weak var object: T?
    
    init(_ object: T) {
        self.object = object
    }
}

extension WeakRefVirtualProxy: FeedLoadingView where T: FeedLoadingView {
    func display(_ isLoading: Bool) {
        object?.display(isLoading)
    }
}

class FeedViewApter: FeedLoadView {
    
    private weak var controller: FeedViewController?
    private let loader: FeedImageDataLoader
    
    init(controller: FeedViewController, imageLoader: FeedImageDataLoader) {
        self.controller = controller
        self.loader = imageLoader
    }
    
    func display(_ feed: [FeedItem]) {
        controller?.display(feed.map { model in
            let viewModel = FeedCellViewModel(imageDataLoader: loader, model: model, imageTransformer: UIImage.init)
            let cellController = FeedCellController(viewModel: viewModel)
            return cellController
        })
    }
}
