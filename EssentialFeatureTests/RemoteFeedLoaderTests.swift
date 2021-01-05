//
//  RemoteFeedLoaderTests.swift
//  EssentialFeatureTests
//
//  Created by Tung Vu Duc on 05/01/2021.
//

import XCTest

class HTTPClient {
    static var shared = HTTPClient()
        
    func get(from url: URL) {}
}

class HTTPClientSpy: HTTPClient {
    var requestedURL: URL?
    
    override func get(from url: URL) {
        requestedURL = url
    }

}

class RemoteFeedLoader {
    
    private let url: URL
    
    init(url: URL = URL(string: "https://a-url.com")!) {
        self.url = url
    }
    
    func load() {
        HTTPClient.shared.get(from: url)
    }
}

class RemoteFeedLoaderTests: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL(){
        let client = HTTPClientSpy()
        HTTPClient.shared = client
        let _ = RemoteFeedLoader()
        
        XCTAssertNil(client.requestedURL)
    }
    
    func test_load_requestsDataFromURL(){
        let url = URL(string: "https://any-url.com")!
        let client = HTTPClientSpy()
        HTTPClient.shared = client
        let sut = RemoteFeedLoader(url: url)
        
        sut.load()
        
        XCTAssertEqual(client.requestedURL, url)
    }
    
}
