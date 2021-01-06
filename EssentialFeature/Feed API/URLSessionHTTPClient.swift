//
//  URLSessionHTTPClient.swift
//  EssentialFeature
//
//  Created by Tung Vu Duc on 06/01/2021.
//

import Foundation

public class URLSessionHTTPClient: HTTPClient {
    
    private let session: URLSession
    
    public init(session: URLSession) {
        self.session = session
    }
    
    public func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) {
        session.dataTask(with: url) { (data, respsonse, error) in
            if let error = error {
                return completion(.failure(error))
            }
            else if let res = respsonse as? HTTPURLResponse, res.statusCode == 200, let data = data {
                completion(.success((data, res)))
            }
        }
        .resume()
    }
    
}
