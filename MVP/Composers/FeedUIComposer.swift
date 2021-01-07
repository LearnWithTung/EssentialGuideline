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

extension WeakRefVirtualProxy: ImageCellView where T: ImageCellView, T.Image == UIImage{
    func display(_ viewModel: ImageCellViewModel<UIImage>) {
        object?.display(viewModel)
    }
}

class FeedCellPresentationAdapter<View: ImageCellView, UIImage>: FeedCellControllerDelegate where View.Image == UIImage{
    
    
    private let model: FeedItem
    private let loader: FeedImageDataLoader
    var presenter: FeedCellPresenter<View, UIImage>?

    init(model: FeedItem, loader: FeedImageDataLoader) {
        self.model = model
        self.loader = loader
    }
    
    func didStartLoadingCell() {
        presenter?.didStartLoadingCell(for: model)
        
        loader.loadImageData(from: model.url) {[weak self] (result) in
            guard let self = self else {return}
            if let data = try? result.get() {
                self.presenter?.didEndLoadingCell(with: data, for: self.model)
            }
        }
    }
}
