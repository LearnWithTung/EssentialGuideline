//
//  RemoteFeedLoaderTests.swift
//  EssentialFeatureTests
//
//  Created by Tung Vu Duc on 05/01/2021.
//

import XCTest

protocol HTTPClient {
    func get(from url: URL, completion: @escaping (Error?, HTTPURLResponse?) -> Void)
}

class RemoteFeedLoader {
    
    private let url: URL
    private let client: HTTPClient
    
    enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    func load(completion: @escaping (Error) -> Void = {_ in}) {
        client.get(from: url) { error, _ in
            if error != nil {
                completion(.connectivity)
            } else {
                completion(.invalidData)
            }
        }
    }
}

class RemoteFeedLoaderTests: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL(){
        let (_, client) = makeSUT(url: anyURL())
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_load_requestsDataFromURL(){
        let url = anyURL()
        let (sut, client) = makeSUT(url: url)
        
        sut.load()
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_loadTwice_requestsDataFromURLTwice() {
        let url = anyURL()
        let (sut, client) = makeSUT(url: url)
        
        sut.load()
        sut.load()
        
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    func test_load_deliversErrorOnConnectivityError() {
        let (sut, client) = makeSUT(url: anyURL())
        let connectivityError = NSError(domain: "test", code: 0, userInfo: nil)
        
        var capturedError: RemoteFeedLoader.Error?
        sut.load() { error in
            capturedError = error
        }
        
        client.complete(with: connectivityError)
        
        XCTAssertEqual(capturedError, .connectivity)
    }
    
    func test_load_deliversErrorOnNon200HTTPURLResponse() {
        let (sut, client) = makeSUT(url: anyURL())

        var capturedError: RemoteFeedLoader.Error?
        sut.load() { error in
            capturedError = error
        }

        client.complete(withStatusCode: 400)

        XCTAssertEqual(capturedError, .invalidData)
    }
    
    // MARK: - Helpers
    private func makeSUT(url: URL) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)

        return (sut, client)
    }
    
    private class HTTPClientSpy: HTTPClient {
        private var messages = [(url: URL, completion: (Error?, HTTPURLResponse?) -> Void)]()
        
        var requestedURLs: [URL] {
            return messages.map {$0.url}
        }
        
        func get(from url: URL, completion: @escaping (Error?, HTTPURLResponse?) -> Void) {
            messages.append((url, completion))
        }
        
        func complete(with error: Error, at index: Int = 0) {
            messages[index].completion(error, nil)
        }
        
        func complete(withStatusCode code: Int, at index: Int = 0){
            let url = requestedURLs[index]
            let response = HTTPURLResponse(url: url, statusCode: code, httpVersion: nil, headerFields: nil)!
            messages[index].completion(nil, response)
        }
    }
    
    private func anyURL() -> URL {
        return URL(string: "https://any-url.com")!
    }
    
}
