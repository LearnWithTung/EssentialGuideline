//
//  FeedUserCell.swift
//  EssentialGuidelineiOS
//
//  Created by Tung Vu Duc on 06/01/2021.
//

import UIKit

public final class FeedUserCell: UITableViewCell {
    @IBOutlet public var emailLabel: UILabel!
    @IBOutlet public var firstNameLabel: UILabel!
    @IBOutlet public var lastNameLabel: UILabel!
    @IBOutlet public var userImageView: UIImageView!
    
    deinit {
        emailLabel.text = nil
        firstNameLabel.text = nil
        lastNameLabel.text = nil
        userImageView.image = nil
    }
}
