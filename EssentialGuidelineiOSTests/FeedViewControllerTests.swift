//
//  FeedViewControllerTests.swift
//  EssentialGuidelineiOSTests
//
//  Created by Tung Vu Duc on 05/01/2021.
//

import XCTest
import UIKit
import EssentialFeature
import EssentialGuidelineiOS

class FeedViewControllerTests: XCTestCase {
    
    func test_loadFeedActions_requestFeedFromLoader() {
        let (sut, loader) = makeSUT()
        
        XCTAssertEqual(loader.requestCallCount, 0, "Expected no loading requets before view is loaded")
        
        sut.loadViewIfNeeded()
        XCTAssertEqual(loader.requestCallCount, 1, "Expected a loading request once view is loaded")
        
        sut.simulateUserInitiatedFeedReload()
        XCTAssertEqual(loader.requestCallCount, 2, "Expected another loading request once user initiates a load")
        
        sut.simulateUserInitiatedFeedReload()
        XCTAssertEqual(loader.requestCallCount, 3, "Expected a third loading request once user intiates another load")
    }
    
    func test_loadingFeedIndicator_isVisibleWhileLoadingFeed() {
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        XCTAssertTrue(sut.isShowingLoadingIndicator, "Expected loading indicaotr once view is loaded")
        
        loader.completeFeedLoading(at: 0)
        XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected no loading indicator once loading is completed")
        
        sut.simulateUserInitiatedFeedReload()
        XCTAssertTrue(sut.isShowingLoadingIndicator, "Expected loading indicator once user initiates a reload")
        
        loader.completeFeedLoading(at: 1)
        XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected no loading indicator once user initiated loading is completed")
    }
    
    // MARK: - Helpers
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: FeedViewController, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let sut = FeedViewController(loader: loader)
        trackForMemoryLeaks(loader)
        trackForMemoryLeaks(sut)
        return (sut, loader)
    }
    
    private func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock {[weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak.", file: file, line: line)
        }
    }
    
    class LoaderSpy: FeedLoader {
        private var messages = [(Result<[FeedItem], Error>) -> Void]()
        var requestCallCount: Int {
            return messages.count
        }
        
        func load(completion: @escaping (Result<[FeedItem], Error>) -> Void) {
            messages.append(completion)
        }
        
        func completeFeedLoading(at index: Int = 0) {
            messages[index](.success([]))
        }
    }
    
}

private extension FeedViewController {
    func simulateUserInitiatedFeedReload() {
        refreshControl?.simulatePullToRefresh()
    }
    
    var isShowingLoadingIndicator: Bool {
        return refreshControl?.isRefreshing == true
    }
}

private extension UIRefreshControl {
    
    func simulatePullToRefresh() {
        self.allTargets.forEach { target in
            actions(forTarget: target, forControlEvent: .valueChanged)?.forEach {
                (target as NSObject).perform(Selector($0))
            }
        }
    }
    
}
