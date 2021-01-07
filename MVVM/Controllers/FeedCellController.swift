//
//  FeedCellController.swift
//  MVC
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

class FeedCellController {
    
    private let viewModel: FeedCellViewModel
    
    init(imageDataLoader: FeedImageDataLoader, model: FeedItem) {
        self.viewModel = FeedCellViewModel(imageDataLoader: imageDataLoader, model: model)
    }
    
    func view(_ tableView: UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedUserCell") as! FeedUserCell
        viewModel.loadImageData()
        return binded(cell)
    }
    
    private func binded(_ cell: FeedUserCell) -> UITableViewCell {
        cell.emailLabel.text = viewModel.email
        cell.firstNameLabel.text = viewModel.firstName
        cell.lastNameLabel.text = viewModel.lastName
        
        viewModel.onImageData = { image in
            cell.userImageView.image = image
        }
        return cell
    }
    
}
