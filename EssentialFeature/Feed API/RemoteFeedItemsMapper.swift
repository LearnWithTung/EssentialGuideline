//
//  RemoteFeedItemsMapper.swift
//  EssentialFeature
//
//  Created by Tung Vu Duc on 05/01/2021.
//

import Foundation

final class RemoteFeedItemsMapper {
    
    struct Root: Decodable {
        let data: [RemoteFeedItem]
    }

    struct RemoteFeedItem: Decodable {
        let id: Int
        let email: String
        let first_name: String
        let last_name: String
        let avatar: URL
        
        var model: FeedItem {
            return FeedItem(id: id, email: email, firstName: first_name, lastName: last_name, url: avatar)
        }
    }
    
    private init() {}
    
    static func map(_ data: Data, _ response: HTTPURLResponse) -> RemoteFeedLoader.Result {
        if response.statusCode == 200, let root = try? JSONDecoder().decode(Root.self, from: data) {
            return .success(root.data.map{$0.model})
        } else {
            return .failure(RemoteFeedLoader.Error.invalidData)
        }
    }
}
