//
//  FeedCellViewModel.swift
//  MVVM
//
//  Created by Tung Vu Duc on 07/01/2021.
//

import UIKit
import EssentialFeature

class FeedCellViewModel {
    typealias Observer<T> = (T) -> Void
    private let imageDataLoader: FeedImageDataLoader
    private let model: FeedItem
    
    init(imageDataLoader: FeedImageDataLoader, model: FeedItem) {
        self.imageDataLoader = imageDataLoader
        self.model = model
    }
    
    var onImageData: Observer<UIImage>?
    
    var email: String {
        return model.email
    }
    
    var firstName: String {
        return model.firstName
    }
    
    var lastName: String {
        return model.lastName
    }

    func loadImageData() {
        imageDataLoader.loadImageData(from: model.url) {[weak self] result in
            let data = try? result.get()
            if let image = data.flatMap(UIImage.init) {
                self?.onImageData?(image)
            }
        }
    }
}
