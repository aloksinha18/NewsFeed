//
//  RemoteFeedLoaderTests.swift
//  NewsAppTests
//
//

import XCTest
@testable import NewsApp

class HTTPClientSpy: HTTPClient {
    
    var requestedURL: [URL] = []
    
    var completion: ((HTTPClientResult) -> Void)?
    
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
        self.completion = completion
        requestedURL.append(url)
    }
    
    func complete(with error: Error) {
        completion?(.failure(error))
    }
    
    func complete(with statusCode: Int, and data: Data = Data()) {
        let response = HTTPURLResponse(url: requestedURL.first!, statusCode: statusCode, httpVersion: nil, headerFields: nil)
        completion?(.success(data, response!))
    }
}

class RemoteFeedLoaderTests: XCTestCase {
    
    func test_init_doesNotLoadDataFromURL() {
        let (_, client) = makeSUT()
        XCTAssertTrue(client.requestedURL.isEmpty)
    }
    
    func test_load_requestDataFromURL() {
        let url = URL(string: "https://a-url.com")!
        let (sut , client) = makeSUT()
        sut.load { _  in}
        XCTAssertEqual(client.requestedURL, [url])
    }
    
    func test_load_deliversErrorOnClientError() {
        let (sut , client) = makeSUT()
        expect(sut, expectedResult: .failure(RemoteFeedLoader.Error.connectivity)) {
            let error = NSError(domain: "Test", code: 404)
            client.complete(with: error)
        }
    }
    
    func test_load_deliversErrorOnNon200HTTPResponse() {
        let (sut , client) = makeSUT()
        expect(sut, expectedResult: .failure(RemoteFeedLoader.Error.invalidData)) {
            client.complete(with: 400)
        }
    }
    
    func test_load_deliverErrorOn200HTTPResponseWithEmptyJson() {
        let (sut , client) = makeSUT()
        expect(sut, expectedResult: .success([])) {
            client.complete(with: 200 , and: "{\"status\" : \"status\",\"totalResults\" : 20 , \"articles\": []}".data(using: .utf8)!)
        }
    }
    
    func test_load_deliverErrorOn200HTTPResponseWithJsonItems() {
        
        let expectedArticle = Article(source: Source(id: "id", name: "name"), author: "author", title: "title", articleDescription: "description", url: "url", urlToImage: "url", publishedAt: "date", content: "content")
        
        let dataString = """
                           {"status" : "status","totalResults": 20 , "articles": [{"source": {"id": "id", "name": "name"}, "title":"title", "author": "author", "description":"description", "url": "url","urlToImage": "url", "publishedAt":"date","content": "content"}]}
                           """
        
        let (sut , client) = makeSUT()
        
        expect(sut, expectedResult: .success([expectedArticle])) {
            client.complete(with: 200 , and: dataString.data(using: .utf8)!)
        }
    }
    
    func test_load_deliverErrorOn200HTTPResponseWithOptionalJsonItems() {
        
        let expectedArticle = Article(source: Source(id: "id", name: "name"), author: nil, title: "title", articleDescription: "description", url: "url", urlToImage: nil, publishedAt: "date", content: nil)
        
        let dataString = """
                           {"status" : "status","totalResults" : 20 , "articles": [{"source": {"id": "id", "name": "name"}, "title":"title", "description":"description", "url": "url", "publishedAt":"date"}]}
                           """
        
        let (sut , client) = makeSUT()
        
        expect(sut, expectedResult: .success([expectedArticle])) {
            client.complete(with: 200 , and: dataString.data(using: .utf8)!)
        }
    }
    
    private func expect(_ sut: RemoteFeedLoader, expectedResult: RemoteFeedLoader.Result, action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "wait to load")
        
        sut.load { result in
            
            switch (result, expectedResult) {
            case let (.success(result), .success(expectedResult)):
                XCTAssertEqual(result, expectedResult, file: file, line: line)

            case let (.failure(result as RemoteFeedLoader.Error), .failure(expectedResult as RemoteFeedLoader.Error)):
                XCTAssertEqual(result, expectedResult, file: file, line: line)
            default:
                XCTFail("expected \(expectedResult) got \(result)")
            }
            
            exp.fulfill()
        }
        
        action()
        wait(for: [exp], timeout: 1.0)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (RemoteFeedLoader, HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(client: client, url: URL(string: "https://a-url.com")!)
        return (sut, client)
    }
}
