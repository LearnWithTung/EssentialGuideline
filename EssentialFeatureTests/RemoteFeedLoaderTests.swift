//
//  RemoteFeedLoaderTests.swift
//  EssentialFeatureTests
//
//  Created by Tung Vu Duc on 05/01/2021.
//

import XCTest

class HTTPClient {
    private init() {}
    static let shared = HTTPClient()
    
    var requestedURL: URL?
}

class RemoteFeedLoader {
    
    func load() {
        HTTPClient.shared.requestedURL = URL(string: "https://a-url.com")
    }
}

class RemoteFeedLoaderTests: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL(){
        let client = HTTPClient.shared
        let _ = RemoteFeedLoader()
        
        XCTAssertNil(client.requestedURL)
    }
    
    func test_load_requestsDataFromURL(){
        let client = HTTPClient.shared
        let sut = RemoteFeedLoader()
        
        sut.load()
        
        XCTAssertNotNil(client.requestedURL)
    }
    
}
