//
//  FeedImageDataLoader.swift
//  EssentialGuidelineiOS
//
//  Created by Tung Vu Duc on 06/01/2021.
//

import Foundation
import SDWebImage

public protocol FeedImageDataLoader {
    func loadImageData(from url: URL, completion: @escaping (Result<Data, Error>) -> Void)
}

public class FeedImageDataLoaderWithSDWebImage : FeedImageDataLoader{
    private let manager = SDWebImageManager()
    
    public init() {}
    
    public func loadImageData(from url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        let manger = SDWebImageManager()
        manger.loadImage(with: url, options: .continueInBackground, progress: nil) { (_, data, error, _, _, _) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(data!))
            }
        }
    }
}
