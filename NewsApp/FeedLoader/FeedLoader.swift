//
//  FeedLoader.swift
//  NewsApp
//
//

import Foundation

protocol FeedImageDataLoader {
    typealias Result = Swift.Result<Data, Error>
    func loadImageData(from url: URL, completion: @escaping (Result) -> Void)
}

protocol FeedLoader {
    typealias Result = Swift.Result<[Article], Error>
    func load(completion: @escaping (Result) -> Void)
}

class RemoteFeedLoader: FeedLoader {
    
    private let client: HTTPClient
    private let url : URL
    
    enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    typealias Result = FeedLoader.Result
    
    init(client: HTTPClient, url: URL) {
        self.client = client
        self.url = url
    }
    
    func load(completion: @escaping (FeedLoader.Result) -> Void) {
        client.get(from: url) { result in
            switch result {
            case .success( let data, let response):
                do {
                    let items =  try FeedItemMapper.map(data, from: response)
                    completion(.success(items))
                } catch {
                    completion(.failure(error))
                }
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
}

class FeedItemMapper {
    
    private static var OK_200: Int { 200 }
    
    static func map(_ data: Data, from response: HTTPURLResponse) throws -> [Article] {
      
        guard response.statusCode == OK_200, let root = try? JSONDecoder().decode(Root.self, from: data) else {
            throw RemoteFeedLoader.Error.invalidData
        }
        
        return root.articles
    }
}
