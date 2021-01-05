//
//  RemoteFeedLoaderTests.swift
//  EssentialFeatureTests
//
//  Created by Tung Vu Duc on 05/01/2021.
//

import XCTest
import EssentialFeature

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
        
        expect(sut, toCompleteWithError: .connectivity) {
            client.complete(with: connectivityError)

        }
    }
    
    func test_load_deliversErrorOnNon200HTTPURLResponse() {
        let (sut, client) = makeSUT(url: anyURL())
        
        let sampleData = [199, 201, 300, 400, 500].enumerated()
        sampleData.forEach { index, value in
            expect(sut, toCompleteWithError: .invalidData) {
                client.complete(withStatusCode: value, at: index)
            }
        }
    }
    
    func test_load_deliversErrorOnInvalidItemJSON() {
        let (sut, client) = makeSUT(url: anyURL())
        
        expect(sut, toCompleteWithError: .invalidData) {
            let invalidData = Data("invalid data".utf8)
            client.complete(withStatusCode: 200, data: invalidData)
        }
    }
    
    func test_load_deliversEmptyFeedOnEmptyItemJSON() {
        let (sut, client) = makeSUT(url: anyURL())
        
        let exp = expectation(description: "wait for completion")
        var capturedItems: [FeedItem]?
        sut.load { result in
            switch result {
            case let .sucess(items):
                capturedItems = items
            default:
                break
            }
            exp.fulfill()
        }
        
        let emptyJSON = Data("{\"items\":[]}".utf8)
        client.complete(withStatusCode: 200, data: emptyJSON)
        
        wait(for: [exp], timeout: 1.0)
        XCTAssertEqual(capturedItems, [])
    }
    
    // MARK: - Helpers
    private func makeSUT(url: URL) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)

        return (sut, client)
    }
    
    private func expect(_ sut: RemoteFeedLoader, toCompleteWithError expectedError: RemoteFeedLoader.Error, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: "Wait for completion")
        
        sut.load() { result in
            switch result {
            case let .failure(error):
                XCTAssertEqual(expectedError, error, file: file, line: line)
            default:
                XCTFail("Expected \(expectedError) got \(result) instead", file: file, line: line)
            }
            exp.fulfill()
        }
        
        action()
        
        wait(for: [exp], timeout: 1.0)
    }
    
    private class HTTPClientSpy: HTTPClient {
        private var messages = [(url: URL, completion: (HTTPClientResult) -> Void)]()
        
        var requestedURLs: [URL] {
            return messages.map {$0.url}
        }
        
        func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
            messages.append((url, completion))
        }
        
        func complete(with error: Error, at index: Int = 0) {
            messages[index].completion(.failure(error))
        }
        
        func complete(withStatusCode code: Int, data: Data = Data(), at index: Int = 0){
            let url = requestedURLs[index]
            let response = HTTPURLResponse(url: url, statusCode: code, httpVersion: nil, headerFields: nil)!
            messages[index].completion(.success(data, response))
        }
    }
    
    private func anyURL() -> URL {
        return URL(string: "https://any-url.com")!
    }
    
}
