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
                completion(RemoteFeedLoader.map(data, response))
            }
        }
    }
    
    private static func map(_ data: Data, _ response: HTTPURLResponse) -> Result {
        if response.statusCode == 200, let root = try? JSONDecoder().decode(Root.self, from: data) {
            return .sucess(root.data.map{$0.model})
        } else {
            return .failure(.invalidData)
        }
    }
}

struct Root: Decodable {
    let data: [RemoteFeedItem]
}

struct RemoteFeedItem: Decodable {
    let id: Int
    let email: String
    let first_name: String
    let last_name: String
    let avatar: String
    
    var model: FeedItem {
        return FeedItem(id: id, email: email, firstName: first_name, lastName: last_name, url: avatar)
    }
}
