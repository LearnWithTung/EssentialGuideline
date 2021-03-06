//
//  FeedCellController.swift
//  MVC
//
//  Created by Tung Vu Duc on 07/01/2021.
//

import UIKit

class FeedCellController {
    
    private let viewModel: FeedCellViewModel<UIImage>
    private var cell: UITableViewCell?
    
    init(viewModel: FeedCellViewModel<UIImage>) {
        self.viewModel = viewModel
    }
    
    func view(_ tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
        cell = binded(tableView.dequeueReusableCell(withIdentifier: "FeedUserCell", for: indexPath) as! FeedUserCell)
        viewModel.loadImageData()
        return cell!
    }
    
    private func binded(_ cell: FeedUserCell) -> UITableViewCell {
        cell.emailLabel.text = viewModel.email
        cell.firstNameLabel.text = viewModel.firstName
        cell.lastNameLabel.text = viewModel.lastName
        cell.userImageView.image = nil
        viewModel.onImageData = {[weak cell] image in
            cell?.userImageView.image = image
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
