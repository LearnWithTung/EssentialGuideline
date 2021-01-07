//
//  FeedCellPresenter.swift
//  MVP
//
//  Created by Tung Vu Duc on 07/01/2021.
//

import Foundation
import EssentialFeature

struct ImageCellViewModel<Image> {
    let email: String
    let firstName: String
    let lastName: String
    var image: Image?
}

protocol ImageCellView {
    associatedtype Image
    func display(_ viewModel: ImageCellViewModel<Image>)
}

class FeedCellPresenter<View: ImageCellView, Image> where View.Image == Image {
    private let imageTransformer: (Data) -> Image?
    private let view: View
    
    init(view: View, imageTransformer: @escaping (Data) -> Image?) {
        self.view = view
        self.imageTransformer = imageTransformer
    }
    
    func didStartLoadingCell(for model: FeedItem) {
        view.display(.init(email: model.email, firstName: model.firstName, lastName: model.lastName, image: nil))
    }

    func didEndLoadingCell(with data: Data, for model: FeedItem) {
        if let image = imageTransformer(data) {
            self.view.display(.init(email: model.email, firstName: model.firstName, lastName: model.lastName, image: image))
        }
    }
}
