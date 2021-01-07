//
//  FeedImageDataLoaderWithSDWebImage.swift
//  EssentialiOSApp
//
//  Created by Tung Vu Duc on 07/01/2021.
//

import Foundation
import EssentialFeature
import SDWebImage

class FeedImageDataLoaderWithSDWebImage : FeedImageDataLoader{
    private let manager = SDWebImageManager()

    public init() {}

    public func loadImageData(from url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        let manger = SDWebImageManager()
        manger.loadImage(with: url, options: .continueInBackground, progress: nil) { (image, _, error, _, _, _) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(image?.pngData() ?? Data()))
            }
        }
    }
}
