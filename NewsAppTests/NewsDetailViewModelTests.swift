//
//  NewsDetailViewModelTests.swift
//  NewsAppTests
//
//

import XCTest
@testable import NewsApp

class NewsDetailViewModelTests: XCTestCase {
    
    func test_currentItem_on_loadImage() {
               let (sut, _) = makeSUT(articles: [firstItem, secondItem, thirdItem])
        XCTAssertEqual(sut.title, firstItem.title)
    }
    
    func test_currentItem_on_swipeLeft() {
        let (sut, _) = makeSUT(articles: [firstItem, secondItem, thirdItem], currentIndex: 1)
        XCTAssertEqual(sut.title, secondItem.title)
        sut.swipeLeft()
        XCTAssertEqual(sut.title, thirdItem.title)
    }
    
    func test_currentItem_on_swipeLeft_withLastItem() {
        let (sut, _) = makeSUT(articles: [firstItem, secondItem, thirdItem], currentIndex: 2)
        XCTAssertEqual(sut.title, thirdItem.title)
        sut.swipeLeft()
        XCTAssertEqual(sut.title, thirdItem.title)
    }
    
    func test_currentItem_on_swipeRight() {
        let (sut, _) = makeSUT(articles: [firstItem, secondItem, thirdItem], currentIndex: 2)
        XCTAssertEqual(sut.title, thirdItem.title)
        sut.swipeRight()
        XCTAssertEqual(sut.title, secondItem.title)
    }
    
    func test_currentItem_on_swipeRight_withFirstItem() {
        let (sut, _) = makeSUT(articles: [firstItem, secondItem, thirdItem], currentIndex: 0)
        XCTAssertEqual(sut.title, firstItem.title)
        sut.swipeRight()
        XCTAssertEqual(sut.title, firstItem.title)
    }

    private var firstItem: Article {
        Article(source: Source(id: UUID().uuidString, name: "first"), author: "james", title: "title1", articleDescription: "description", url: "any-url", urlToImage: "any-url", publishedAt: "any date", content: "content")
    }
    
    private var secondItem: Article {
        Article(source: Source(id: UUID().uuidString, name: "first"), author: "james", title: "title2", articleDescription: "description", url: "any-url", urlToImage: "any-url", publishedAt: "any date", content: "content")
    }
    
    private var thirdItem: Article {
        Article(source: Source(id: UUID().uuidString, name: "first"), author: "james", title: "title3", articleDescription: "description", url: "any-url", urlToImage: "any-url", publishedAt: "any date", content: "content")
    }
    private func makeSUT(articles: [Article], currentIndex: Int = 0) -> (NewsDetailViewModel, HTTPClientSpy) {
        let httpClient = HTTPClientSpy()
        let viewModel = NewsDetailViewModel(articles: articles, currentIndex: currentIndex, loader: RemoteFeedImageDataLoader(client: httpClient))
        return(viewModel, httpClient)
    }
    
    func anyURL() -> URL {
        return URL(string: "http://any-url.com")!
    }
}
