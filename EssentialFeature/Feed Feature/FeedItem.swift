//
//  FeedItem.swift
//  EssentialFeature
//
//  Created by Tung Vu Duc on 05/01/2021.
//

import Foundation

public struct FeedItem: Equatable, Decodable {
    public let id: Int
    public let email: String
    public let firstName: String
    public let lastName: String
    public let url: String
    
    public init(id: Int, email: String, firstName: String, lastName: String, url: String) {
        self.id = id
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.url = url
    }
    
    public enum CodingKeys: String, CodingKey {
        case id
        case email
        case firstName = "first_name"
        case lastName = "last_name"
        case url = "avatar"
    }
}
