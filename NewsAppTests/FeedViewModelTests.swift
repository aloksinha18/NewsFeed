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
        sut.onFeedLoad = { result in
            XCTAssertEqual(sut.articles.count, 1)
        }
        let dataString = """
                           {"status" : "status","totalResults": 20 , "articles": [{"source": {"id": "id", "name": "name"}, "title":"title", "author": "author", "description":"description", "url": "url","urlToImage": "url", "publishedAt":"date","content": "content"}]}
                           """
        client.complete(with: 200, and: dataString.data(using: .utf8)!)
        expectation.fulfill()
        wait(for: [expectation], timeout: 1.0)
        
    }
    
    func test_refresh_OnSuccessfulEmptyResponse() {
        let (sut, client) = makeSUT()
        
        let expectation = expectation(description: "wait for load")
        
        sut.refresh()
        sut.onFeedLoad = { result in
            XCTAssertEqual(sut.articles.count, 0)
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
    
    func anyURL() -> URL {
        return URL(string: "http://any-url.com")!
    }
}
