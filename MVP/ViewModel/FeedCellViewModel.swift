//
//  FeedCellViewModel.swift
//  MVVM
//
//  Created by Tung Vu Duc on 07/01/2021.
//

import Foundation
import EssentialFeature

class FeedCellViewModel<Image> {
    typealias Observer<T> = (T) -> Void
    private let imageDataLoader: FeedImageDataLoader
    private let model: FeedItem
    private let imageTransformer: (Data) -> Image?
    
    init(imageDataLoader: FeedImageDataLoader, model: FeedItem, imageTransformer: @escaping (Data) -> Image?) {
        self.imageDataLoader = imageDataLoader
        self.model = model
        self.imageTransformer = imageTransformer
    }
    
    var onImageData: Observer<Image>?
    
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
            if let self = self, let image = data.flatMap(self.imageTransformer) {
                self.onImageData?(image)
            }
        }
    }
}
