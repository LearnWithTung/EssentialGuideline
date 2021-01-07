//
//  FeedViewApter.swift
//  MVP
//
//  Created by Tung Vu Duc on 07/01/2021.
//

import EssentialFeature
import UIKit

extension WeakRefVirtualProxy: FeedLoadingView where T: FeedLoadingView {
    func display(_ viewModel: FeedLoadingModel) {
        object?.display(viewModel)
    }
}

class FeedViewApter: FeedLoadView {
    
    private weak var controller: FeedViewController?
    private let loader: FeedImageDataLoader
    
    init(controller: FeedViewController, imageLoader: FeedImageDataLoader) {
        self.controller = controller
        self.loader = imageLoader
    }
    
    func display(_ viewModel: FeedLoadViewModel) {
        controller?.display(viewModel.feed.map {[] model in
            let adapter = FeedCellPresentationAdapter<WeakRefVirtualProxy<FeedCellController>, UIImage>(model: model, loader: loader)
            let cellController = FeedCellController(delegate: adapter)
            adapter.presenter = FeedCellPresenter(view: WeakRefVirtualProxy(cellController), imageTransformer: UIImage.init)
            return cellController
        })
    }
}
