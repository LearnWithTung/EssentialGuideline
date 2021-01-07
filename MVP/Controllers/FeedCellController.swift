//
//  FeedCellController.swift
//  MVC
//
//  Created by Tung Vu Duc on 07/01/2021.
//

import UIKit

protocol FeedCellControllerDelegate {
    func didStartLoadingCell()
}

class FeedCellController: ImageCellView {
    
    private let delegate: FeedCellControllerDelegate
    private var cell: FeedUserCell?
    
    init(delegate: FeedCellControllerDelegate) {
        self.delegate = delegate
    }
    
    func view(_ tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
        cell = (tableView.dequeueReusableCell(withIdentifier: "FeedUserCell", for: indexPath) as! FeedUserCell)
        delegate.didStartLoadingCell()
        return cell!
    }
    
    func display(_ viewModel: ImageCellViewModel<UIImage>) {
        cell?.emailLabel.text = viewModel.email
        cell?.firstNameLabel.text = viewModel.firstName
        cell?.lastNameLabel.text = viewModel.lastName
        cell?.userImageView?.image = viewModel.image
    }
    
    deinit {
        dequeueCellForReuse()
    }
    
    private func dequeueCellForReuse(){
        cell = nil
    }
    
}
