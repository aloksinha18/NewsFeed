//
//  FeedViewModelTests.swift
//  NewsAppTests
//
//

import XCTest
@testable import NewsApp

class FeedViewModelTests: XCTestCase {
    
    func test_refresh_OnSuccessfulResponse() {
        let (sut, client) = makeSUT()
        
        let expectation = expectation(description: "wait for load")
        
        sut.refresh()
        let (article, data) = makeArticle()
        
        sut.onFeedLoad = { result in
            XCTAssertEqual(result, article)
        }
        
        client.complete(with: 200, and: data)
        expectation.fulfill()
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_refresh_OnSuccessfulEmptyResponse() {
        let (sut, client) = makeSUT()
        
        let expectation = expectation(description: "wait for load")
        
        
        sut.refresh()
        sut.onFeedLoad = { result in
            XCTAssertEqual(result, [])
        }
        
        let dataString = """
                           {"status" : "status","totalResults": 20 , "articles": []}
                           """
        client.complete(with: 200, and: dataString.data(using: .utf8)!)
        expectation.fulfill()
        wait(for: [expectation], timeout: 1.0)
    }
    
    private func makeSUT() -> (FeedViewModel, HTTPClientSpy) {
        let httpSpy = HTTPClientSpy()
        let remoteFeedLoader = RemoteFeedLoader(client: httpSpy, url: anyURL())
        
        let viewModel = FeedViewModel(feedLoader: remoteFeedLoader, imageLoader: RemoteFeedImageDataLoader(client: httpSpy))
        return(viewModel, httpSpy)
    }
    
    private func makeArticle() -> ([Article], Data) {
        let article = Article(source: Source(id: "id", name: "name"), author: "author", title: "title", articleDescription: "description", url: "url", urlToImage: "url", publishedAt: "date", content: "content")
        let dataString = """
                           {"status" : "status","totalResults": 20 , "articles": [{"source": {"id": "\(article.source.id ?? "")"), "name": "\(article.source.name)")}, "title":"\(article.title)", "author": "\(article.author ?? "")", "description":"\(article.articleDescription ?? "")", "url": "\(article.url)","urlToImage": "\(article.urlToImage ?? "")", "publishedAt":"\(article.publishedAt)","content": "\(article.content ?? "")"}]}
                         """
        return ([article], dataString.data(using: .utf8)!)
    }
    
    func anyURL() -> URL {
        return URL(string: "http://any-url.com")!
    }
}
