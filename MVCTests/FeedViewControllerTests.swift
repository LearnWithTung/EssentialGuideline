//
//  FeedViewControllerTests.swift
//  MVCTests
//
//  Created by Tung Vu Duc on 07/01/2021.
//
import XCTest
import UIKit
import EssentialFeature
import MVC

class FeedViewControllerTests: XCTestCase {
    
    func test_loadFeedActions_requestFeedFromLoader() {
        let (sut, loader) = makeSUT()
        
        XCTAssertEqual(loader.loadFeedCallCount, 0, "Expected no loading requets before view is loaded")
        
        sut.loadViewIfNeeded()
        XCTAssertEqual(loader.loadFeedCallCount, 1, "Expected a loading request once view is loaded")
        
        sut.simulateUserInitiatedFeedReload()
        XCTAssertEqual(loader.loadFeedCallCount, 2, "Expected another loading request once user initiates a load")
        
        sut.simulateUserInitiatedFeedReload()
        XCTAssertEqual(loader.loadFeedCallCount, 3, "Expected a third loading request once user intiates another load")
    }
    
    func test_loadingFeedIndicator_isVisibleWhileLoadingFeed() {
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        XCTAssertTrue(sut.isShowingLoadingIndicator, "Expected loading indicaotr once view is loaded")
        
        loader.completeFeedLoading(at: 0)
        XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected no loading indicator once loading is completed successfully")
        
        sut.simulateUserInitiatedFeedReload()
        XCTAssertTrue(sut.isShowingLoadingIndicator, "Expected loading indicator once user initiates a reload")
        
        loader.completeFeedLoadingWithError(at: 1)
        XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected no loading indicator once user initiated loading is completed with error")
    }
    
    func test_loadFeedCompletion_rendersSuccessfullyLoadedFeed() {
        let user0 = makeItem(id: 1)
        let user1 = makeItem(id: 2, email: "another email", firstname: "another firstname", lastname: "another lastname", url: URL(string: "https://another-url.com")!)
        let user2 = makeItem(id: 3, email: "a another email", firstname: "a another firstname", lastname: "a another lastname", url: URL(string:"https://a-another-url.com")!)
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        assertThat(sut, hasRendering: [])

        loader.completeFeedLoading(with: [user0], at: 0)
        assertThat(sut, hasRendering: [user0])
        
        sut.simulateUserInitiatedFeedReload()
        loader.completeFeedLoading(with: [user0, user1, user2], at: 1)
        assertThat(sut, hasRendering: [user0, user1, user2])
    }
    
    func test_loadFeedCompletion_doesNotAlterCurrentRenderingStateOnError() {
        let user0 = makeItem(id: 1)
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        loader.completeFeedLoading(with: [user0], at: 0)

        sut.simulateUserInitiatedFeedReload()
        loader.completeFeedLoadingWithError(at: 1)
        assertThat(sut, hasRendering: [user0])
    }
    
    func test_feedUserView_loadsImageURLWhenVisible() {
        let user0 = makeItem(id: 1, url: URL(string: "https://url-0.com")!)
        let user1 = makeItem(id: 1, url: URL(string: "https://url-1.com")!)
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        loader.completeFeedLoading(with: [user0, user1])
        
        XCTAssertEqual(loader.loadedUserURLs, [], "Expected no image URL requested until view become visible")
        
        sut.simulateFeedUserViewVisisble(at: 0)
        XCTAssertEqual(loader.loadedUserURLs, [user0.url], "Expected first image URL request once first view becomes visible")

        sut.simulateFeedUserViewVisisble(at: 1)
        XCTAssertEqual(loader.loadedUserURLs, [user0.url, user1.url], "Expected second image URL request once second view becomes visible")
    }
    
    func test_feedUserView_rendersImageLoadedFromURL() {
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        loader.completeFeedLoading(with: [makeItem(id: 1), makeItem(id: 2)])
        
        let view0 = sut.simulateFeedUserViewVisisble(at: 0)
        let view1 = sut.simulateFeedUserViewVisisble(at: 1)
        XCTAssertEqual(view0?.renderedImage, .none, "Expected no image for first view while loading first image")
        XCTAssertEqual(view1?.renderedImage, .none, "Expected no image for second view while loading first image")
        
        let imageData0 = UIImage.make(with: .red)!.pngData()!
        loader.completeImageLoading(with: imageData0, at: 0)
        XCTAssertEqual(view0?.renderedImage, imageData0)
        XCTAssertEqual(view1?.renderedImage, .none, "Expected no image for second view while loading first image")
        
        let imageData1 = UIImage.make(with: .blue)!.pngData()!
        loader.completeImageLoading(with: imageData1, at: 1)
        XCTAssertEqual(view0?.renderedImage, imageData0)
        XCTAssertEqual(view1?.renderedImage, imageData1)

    }
    
    func test_loadFeedCompletion_dispatchesFromBackgroundToMainThread() {
        let (sut, loader) = makeSUT()
        sut.loadViewIfNeeded()
        
        let exp = expectation(description: "Wait for completion")
        DispatchQueue.global().async {
            loader.completeFeedLoading(at: 0)
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 0.1, handler: nil)
    }
    
    // MARK: - Helpers
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: FeedViewController, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let sut = FeedUIComposer.composeWith(feedLoader: loader, imageLoader: loader)
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, loader)
    }
    
    private func makeItem(id: Int, email: String = "any", firstname: String = "any", lastname: String = "any", url: URL = URL(string: "https://any-url.com")!) -> FeedItem {
        return FeedItem(id: id, email: email, firstName: firstname, lastName: lastname, url: url)
    }

    
    private func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock {[weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak.", file: file, line: line)
        }
    }
    
    private func assertThat(_ sut: FeedViewController, hasViewConfiguredFor user: FeedItem, at index: Int, file: StaticString = #filePath, line: UInt = #line) {
        let view = sut.feedUserView(at: index)
        guard let cell = view as? FeedUserCell else {
            return XCTFail("Expected \(FeedUserCell.self) instance")
        }
        
        XCTAssertEqual(cell.emailText, user.email, file: file, line: line)
        XCTAssertEqual(cell.firstNameText, user.firstName, file: file, line: line)
        XCTAssertEqual(cell.lastNameText, user.lastName, file: file, line: line)
    }
    
    private func assertThat(_ sut: FeedViewController, hasRendering users: [FeedItem], file: StaticString = #filePath, line: UInt = #line) {
        guard sut.numberOfRenderedFeedUserViews() == users.count else {
            return XCTFail("Expected \(users.count) users, got \(sut.numberOfRenderedFeedUserViews()) instead", file: file, line: line)
        }
        users.enumerated().forEach { index, user in
            assertThat(sut, hasViewConfiguredFor: user, at: index, file: file, line: line)
        }
    }
    
    class LoaderSpy: FeedLoader, FeedImageDataLoader {
        // MARK: - FeedLoader
        
        private var feedMessages = [(Result<[FeedItem], Error>) -> Void]()
        var loadFeedCallCount: Int {
            return feedMessages.count
        }
                
        func load(completion: @escaping (Result<[FeedItem], Error>) -> Void) {
            feedMessages.append(completion)
        }
        
        func completeFeedLoading(with feed: [FeedItem] = [], at index: Int = 0) {
            feedMessages[index](.success(feed))
        }
        
        func completeFeedLoadingWithError(at index: Int = 0) {
            let error = NSError(domain: "test", code: 0, userInfo: nil)
            feedMessages[index](.failure(error))
        }
        
        // MARK: - FeedImageDataLoader
        
        var loadedUserURLs: [URL] = []
        var loadImageDataMessages = [(Result<Data, Error>) -> Void]()
        
        func loadImageData(from url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
            loadedUserURLs.append(url)
            loadImageDataMessages.append(completion)
        }
        
        func completeImageLoading(with data: Data, at index: Int = 0) {
            loadImageDataMessages[index](.success(data))
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
    
    @discardableResult
    func simulateFeedUserViewVisisble(at index: Int) -> FeedUserCell? {
        return feedUserView(at: index) as? FeedUserCell
    }
    
    func numberOfRenderedFeedUserViews() -> Int {
        return tableView.numberOfRows(inSection: feedImagesSection)
    }
    
    func feedUserView(at row: Int) -> UITableViewCell? {
        guard numberOfRenderedFeedUserViews() > row else {
            return nil
        }
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
    
    var renderedImage: Data? {
        return userImageView.image?.pngData()
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

private extension UIImage {
    static func make(with color: UIColor) -> UIImage? {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor)
        context.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
