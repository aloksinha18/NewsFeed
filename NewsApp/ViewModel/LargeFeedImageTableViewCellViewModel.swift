//
//  LargeFeedImageTableViewCellViewModel.swift
//  NewsApp
//
//

import UIKit

struct DefaultFeedImageTableViewCellViewModel {
    let article: Article
    let imageLoader: FeedImageDataLoader
    
    func loadImage(url: URL,completion: @escaping (UIImage?) -> Void) {
        imageLoader.loadImageData(from: url) { result in
            switch result {
            case .success( let data):
                completion(UIImage(data: data))
            case .failure:
                completion(nil)
            }
        }
    }
}
