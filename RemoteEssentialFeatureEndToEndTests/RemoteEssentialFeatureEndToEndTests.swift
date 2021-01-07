//
//  RemoteEssentialFeatureEndToEndTests.swift
//  RemoteEssentialFeatureEndToEndTests
//
//  Created by Tung Vu Duc on 07/01/2021.
//

import XCTest
import EssentialFeature

class RemoteEssentialFeatureEndToEndTests: XCTestCase {

    func test_endToEndTestServerGETFeedResult_matchesFixedTestData() {
        let loader = RemoteFeedLoader(url: feedTestServerURL, client: ephemeralClient())
        let exp = expectation(description: "Wait for completion")
        
        loader.load { (result) in
            switch result {
            case let .failure(error):
                XCTFail("Expected load feed successfully got \(error) instead")
            case let .success(feed):
                XCTAssertEqual(feed.count, 6)
                XCTAssertEqual(feed[0], self.fixedFeedItem(at: 0))
                XCTAssertEqual(feed[1], self.fixedFeedItem(at: 1))
                XCTAssertEqual(feed[2], self.fixedFeedItem(at: 2))
                XCTAssertEqual(feed[3], self.fixedFeedItem(at: 3))
                XCTAssertEqual(feed[4], self.fixedFeedItem(at: 4))
                XCTAssertEqual(feed[5], self.fixedFeedItem(at: 5))
            }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 5.0)
    }
    
    private var feedTestServerURL: URL {
        return URL(string: "https://reqres.in/api/users?page=2")!
    }
    
    private func ephemeralClient(file: StaticString = #filePath, line: UInt = #line) -> HTTPClient {
        let client = URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
        trackForMemoryLeaks(client, file: file, line: line)
        return client
    }
    
    private func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock {[weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak.", file: file, line: line)
        }
    }
    
    private func fixedFeedItem(at index: Int) -> FeedItem {
        let items = [
            FeedItem(id: 7, email: "michael.lawson@reqres.in", firstName: "Michael", lastName: "Lawson", url: URL(string: "https://reqres.in/img/faces/7-image.jpg")!),
            FeedItem(id: 8, email: "lindsay.ferguson@reqres.in", firstName: "Lindsay", lastName: "Ferguson", url: URL(string: "https://reqres.in/img/faces/8-image.jpg")!),
            FeedItem(id: 9, email: "tobias.funke@reqres.in", firstName: "Tobias", lastName: "Funke", url: URL(string: "https://reqres.in/img/faces/9-image.jpg")!),
            FeedItem(id: 10, email: "byron.fields@reqres.in", firstName: "Byron", lastName: "Fields", url: URL(string: "https://reqres.in/img/faces/10-image.jpg")!),
            FeedItem(id: 11, email: "george.edwards@reqres.in", firstName: "George", lastName: "Edwards", url: URL(string: "https://reqres.in/img/faces/11-image.jpg")!),
            FeedItem(id: 12, email: "rachel.howell@reqres.in", firstName: "Rachel", lastName: "Howell", url: URL(string: "https://reqres.in/img/faces/12-image.jpg")!)
        ]
        return items[index]
    }

}
