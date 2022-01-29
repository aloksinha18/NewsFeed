//
//  RemoteFeedImageDataLoader.swift
//  NewsApp
//
//

import Foundation

final class RemoteFeedImageDataLoader: FeedImageDataLoader {
    
    typealias Result = FeedImageDataLoader.Result
    
    private let client: HTTPClient
    
    init(client: HTTPClient) {
        self.client = client
    }
    
    enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    func loadImageData(from url: URL, completion: @escaping (Result) -> Void)   {
        
        client.get(from: url) { result in
            switch result {
                
            case .success( let data, let response):
                if response.statusCode == 200 && !data.isEmpty {
                    completion(.success(data))
                } else {
                    completion(.failure(Error.invalidData))
                }
            case .failure:
                completion(.failure(Error.invalidData))
            }
        }
    }
}
