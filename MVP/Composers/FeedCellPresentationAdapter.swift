//
//  FeedCellPresentationAdapter.swift
//  MVP
//
//  Created by Tung Vu Duc on 07/01/2021.
//

import UIKit
import EssentialFeature

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
