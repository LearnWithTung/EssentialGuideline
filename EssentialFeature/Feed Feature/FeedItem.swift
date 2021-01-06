//
//  FeedItem.swift
//  EssentialFeature
//
//  Created by Tung Vu Duc on 05/01/2021.
//

import Foundation

public struct FeedItem: Equatable {
    public let id: Int
    public let email: String
    public let firstName: String
    public let lastName: String
    public let url: URL
    
    public init(id: Int, email: String, firstName: String, lastName: String, url: URL) {
        self.id = id
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.url = url
    }
}
