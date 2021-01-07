//
//  FeedRefreshController.swift
//  MVC
//
//  Created by Tung Vu Duc on 07/01/2021.
//

import UIKit

public final class FeedRefreshController: NSObject {
    
    lazy var view = binded(UIRefreshControl())
    
    private let viewModel: FeedRefreshViewModel
    
    public init(viewModel: FeedRefreshViewModel) {
        self.viewModel = viewModel
    }
    
    @objc func refresh() {
        viewModel.load()
    }
    
    private func binded(_ view: UIRefreshControl) -> UIRefreshControl {
        viewModel.onFeedLoadState = { [weak self] isLoading in
            func refresh() {
                if isLoading {
                    self?.view.beginRefreshing()
                } else {
                    self?.view.endRefreshing()
                }
            }
            if Thread.isMainThread {
                refresh()
            } else {
                DispatchQueue.main.async {
                    refresh()
                }
            }
        }
        
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return view
    }
}
