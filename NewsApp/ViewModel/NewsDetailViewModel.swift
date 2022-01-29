//
//  NewsDetailViewModel.swift
//  NewsAppTests
//
//

import Foundation

class NewsDetailViewModel {
    let articles: [Article]
    var currentIndex: Int
    let imageLoader: FeedImageDataLoader
    
    init(articles: [Article], currentIndex: Int, loader: FeedImageDataLoader) {
        self.articles = articles
        self.currentIndex = currentIndex
        self.imageLoader = loader
    }
    
    var onSwipeCompletion: ((Article) -> Void )?
    
    var title: String {
        articles[currentIndex].title
    }
    
    func loadImage(completion: @escaping (Data?) -> Void) {
        guard let url = URL(string: articles[currentIndex].urlToImage ?? "") else {
            completion(nil)
            return
        }
        
        imageLoader.loadImageData(from: url) { result in
            switch result {
            case .success(let data):
                completion(data)
            case .failure:
                completion(nil)
            }
        }
    }
    
    func swipeLeft() {
        if currentIndex == articles.count - 1 {
            return
        }
        currentIndex += 1
        onSwipeCompletion?(articles[currentIndex])
    }
    
    func swipeRight() {
        if currentIndex == 0 {
            return
        }
        currentIndex -= 1
        onSwipeCompletion?(articles[currentIndex])
    }
    
    func canSwiftLeft() -> Bool {
        return currentIndex != articles.count - 1
    }
    
    func canSwiftRight() -> Bool {
        return currentIndex != 0
    }
}
