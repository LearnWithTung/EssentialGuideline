//
//  FeedViewControllerTests.swift
//  EssentialGuidelineiOSTests
//
//  Created by Tung Vu Duc on 05/01/2021.
//

import XCTest
import UIKit
import EssentialFeature

final class FeedViewController: UIViewController {
    
    private var loader: FeedLoader?
        
    convenience init(loader: FeedLoader) {
        self.init()
        
        self.loader = loader
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loader?.load() {_ in}
    }
    
}

class FeedViewControllerTests: XCTestCase {
    
    func test_init_doesNotLoadFeed() {
        let loader = LoaderSpy()
        let _ = FeedViewController(loader: loader)
        
        XCTAssertEqual(loader.requestCallCount, 0)
    }
    
    func test_viewDidLoad_loadsFeed() {
        let loader = LoaderSpy()
        let sut = FeedViewController(loader: loader)
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(loader.requestCallCount, 1)
    }
    
    class LoaderSpy: FeedLoader {
        private(set) var requestCallCount: Int = 0
        
        func load(completion: @escaping (Result<[FeedItem], Error>) -> Void) {
            requestCallCount += 1
        }
    }
    
}
