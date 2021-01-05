//
//  HTTPClient.swift
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
