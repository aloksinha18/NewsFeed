//
//  FeedViewModel.swift
//  NewsApp
//
//

import Foundation

class FeedViewModel {
    
    let feedLoader: FeedLoader
    let imageLoader: FeedImageDataLoader
    
    var onLoadingStateChange: ((Bool) -> Void )?
    var onFeedLoad: (([Article]) -> Void )?
    
    init(feedLoader: FeedLoader,
         imageLoader: FeedImageDataLoader) {
        self.feedLoader = feedLoader
        self.imageLoader = imageLoader
    }
    
    func refresh() {
        onLoadingStateChange?(true)
        feedLoader.load { [weak self] result in
            if let feeds = try? result.get() {
                self?.onFeedLoad?(feeds)
            }
            self?.onLoadingStateChange?(false)
        }
    }
}
