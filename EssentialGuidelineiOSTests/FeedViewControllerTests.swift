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
    
    func test_loadFeedCompletion_rendersSuccessfullyLoadedFeed() {
        let user0 = makeItem(id: 1)
        let user1 = makeItem(id: 2, email: "another email", firstname: "another firstname", lastname: "another lastname", url: "https://another-url.com")
        let user2 = makeItem(id: 3, email: "a another email", firstname: "a another firstname", lastname: "a another lastname", url: "https://a-another-url.com")
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        assertThat(sut, hasRendering: [])

        loader.completeFeedLoading(with: [user0], at: 0)
        assertThat(sut, hasRendering: [user0])
        
        sut.simulateUserInitiatedFeedReload()
        loader.completeFeedLoading(with: [user0, user1, user2], at: 1)
        assertThat(sut, hasRendering: [user0, user1, user2])
    }
    
    // MARK: - Helpers
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: FeedViewController, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let sut = FeedViewController(loader: loader)
        trackForMemoryLeaks(loader)
        trackForMemoryLeaks(sut)
        return (sut, loader)
    }
    
    private func makeItem(id: Int, email: String = "any", firstname: String = "any", lastname: String = "any", url: String = "https://any-url.com") -> FeedItem {
        return FeedItem(id: id, email: email, firstName: firstname, lastName: lastname, url: url)
    }

    
    private func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock {[weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak.", file: file, line: line)
        }
    }
    
    private func assertThat(_ sut: FeedViewController, hasViewConfiguredFor user: FeedItem, at index: Int, file: StaticString = #filePath, line: UInt = #line) {
        let view = sut.feedUserView(at: index) as? FeedUserCell
        XCTAssertNotNil(view, file: file, line: line)
        XCTAssertEqual(view?.emailText, user.email, file: file, line: line)
        XCTAssertEqual(view?.firstNameText, user.firstName, file: file, line: line)
        XCTAssertEqual(view?.lastNameText, user.lastName, file: file, line: line)
    }
    
    private func assertThat(_ sut: FeedViewController, hasRendering users: [FeedItem]) {
        XCTAssertEqual(sut.numberOfRenderedFeedUserViews(), users.count)
        users.enumerated().forEach { index, user in
            assertThat(sut, hasViewConfiguredFor: user, at: index)
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
        
        func completeFeedLoading(with feed: [FeedItem] = [], at index: Int = 0) {
            messages[index](.success(feed))
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
    
    func numberOfRenderedFeedUserViews() -> Int {
        return tableView.numberOfRows(inSection: feedImagesSection)
    }
    
    func feedUserView(at row: Int) -> UITableViewCell? {
        let ds = tableView.dataSource
        let index = IndexPath(row: row, section: feedImagesSection)
        return ds?.tableView(tableView, cellForRowAt: index)
    }
    
    private var feedImagesSection: Int {
        return 0
    }
}

private extension FeedUserCell {
    var emailText: String? {
        return emailLabel.text
    }
    
    var firstNameText: String? {
        return firstNameLabel.text
    }
    
    var lastNameText: String? {
        return lastNameLabel.text
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
