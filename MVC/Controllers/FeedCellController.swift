//
//  FeedCellController.swift
//  MVC
//
//  Created by Tung Vu Duc on 07/01/2021.
//

import UIKit
import EssentialFeature

class FeedCellController {
    
    private let imageDataLoader: FeedImageDataLoader
    private let model: FeedItem
    private var cell: UITableViewCell?
    
    init(imageDataLoader: FeedImageDataLoader, model: FeedItem) {
        self.imageDataLoader = imageDataLoader
        self.model = model
    }
    
    func view(_ tableView: UITableView) -> UITableViewCell {
        let cell: FeedUserCell = tableView.dequeueReusableCell(withIdentifier: "FeedUserCell") as! FeedUserCell
        self.cell = cell
        cell.emailLabel.text = model.email
        cell.firstNameLabel.text = model.firstName
        cell.lastNameLabel.text = model.lastName
        cell.userImageView.image = nil
        imageDataLoader.loadImageData(from: model.url) { result in
            let data = try? result.get()
            cell.userImageView.image = data.map(UIImage.init) ?? nil
        }
        return cell
    }
    
    deinit {
        dequeueCellForReuse()
    }
    
    private func dequeueCellForReuse(){
        cell = nil
    }
}
