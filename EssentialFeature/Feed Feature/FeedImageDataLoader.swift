//
//  FeedImageDataLoader.swift
//  EssentialFeature
//
//  Created by Tung Vu Duc on 07/01/2021.
//

import Foundation

public protocol FeedImageDataLoader {
    func loadImageData(from url: URL, completion: @escaping (Result<Data, Error>) -> Void)
}
