//
//  FeedRefreshController.swift
//  MVC
//
//  Created by Tung Vu Duc on 07/01/2021.
//

import UIKit

public final class FeedRefreshController: NSObject, FeedLoadingView {
    
    lazy var view = self.view(UIRefreshControl())
    
    private let presenter: FeedPresenter
    
    public init(presenter: FeedPresenter) {
        self.presenter = presenter
    }
    
    @objc func refresh() {
        presenter.didStartReloadFeed()
    }
    
    func display(_ isLoading: Bool) {
        if Thread.isMainThread {
            if isLoading {
                view.beginRefreshing()
            } else {
                view.endRefreshing()
            }
        } else {
            DispatchQueue.main.async {[weak self] in
                if isLoading {
                    self?.view.beginRefreshing()
                } else {
                    self?.view.endRefreshing()
                }
            }
        }
    }
    
    private func view(_ view: UIRefreshControl) -> UIRefreshControl {
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return view
    }
}
