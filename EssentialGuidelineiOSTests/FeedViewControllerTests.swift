//
//  FeedViewControllerTests.swift
//  EssentialGuidelineiOSTests
//
//  Created by Tung Vu Duc on 05/01/2021.
//

import XCTest

final class FeedViewController {
        
    init(loader: FeedViewControllerTests.LoaderSpy) {
        
    }
    
}

class FeedViewControllerTests: XCTestCase {
    
    func test_init_doesNotLoadFeed() {
        let loader = LoaderSpy()
        let _ = FeedViewController(loader: loader)
        
        XCTAssertEqual(loader.requestCallCount, 0)
    }
    
    class LoaderSpy {
        var requestCallCount: Int = 0
    }
    
}
