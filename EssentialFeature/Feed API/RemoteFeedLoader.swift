//
//  RemoteFeedLoader.swift
//  EssentialFeature
//
//  Created by Tung Vu Duc on 05/01/2021.
//

import Foundation

public enum HTTPClientResult {
    case success(Data, HTTPURLResponse)
    case failure(Error)
}

public protocol HTTPClient {
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void)
}

public class RemoteFeedLoader {
    
    private let url: URL
    private let client: HTTPClient
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public enum Result {
        case sucess([FeedItem])
        case failure(Error)
    }
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public func load(completion: @escaping (Result) -> Void = {_ in}) {
        client.get(from: url) { result in
            switch result {
            case .failure:
                completion(.failure(.connectivity))
            case let .success(data, response):
                if response.statusCode == 200, let root = try? JSONDecoder().decode(Root.self, from: data) {
                    completion(.sucess(root.data))
                } else {
                    completion(.failure(.invalidData))
                }
            }
        }
    }
}

struct Root: Decodable {
    let data: [FeedItem]
}
