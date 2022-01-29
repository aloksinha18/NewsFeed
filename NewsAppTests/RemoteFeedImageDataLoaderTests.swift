//
//  RemoteFeedImageDataLoaderTests.swift
//  NewsAppTests
//
//

import XCTest
@testable import NewsApp

class RemoteFeedImageDataLoaderTests: XCTestCase {
    
    func test_loadImageDataFromURL_deliversInvalidDataErrorOn200HTTPResponseWithEmptyData() {
        let (sut, client) = makeSUT()
        let exp = expectation(description: "Wait for load completion")
        
        let emptyData = Data()
        
        sut.loadImageData(from: anyURL()) { result in
            switch result {
            case let (.failure(receivedError as NSError)):
                XCTAssertEqual(receivedError, RemoteFeedImageDataLoader.Error.invalidData as NSError)
            default:
                XCTFail("Expecting failure")
            }
        }
        
        client.complete(with: 200, and: emptyData)
        exp.fulfill()
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_loadImageDataFromURL_deliversInvalidDataErrorOn200HTTPResponseWithNonEmptyData() {
        let (sut, client) = makeSUT()
        let exp = expectation(description: "Wait for load completion")
        
        let nonEmptyData = "npn-empty data".data(using: .utf8)!
        
        sut.loadImageData(from: anyURL()) { result in
            switch result {
            case let (.success(data)):
                XCTAssertEqual(data, nonEmptyData)
            default:
                XCTFail("Expecting success")
            }
        }
        
        client.complete(with: 200, and: nonEmptyData)
        exp.fulfill()
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_loadImageDataFromURL_deliversInvalidDataErrorOnNon200HTTPResponse() {
        let (sut, client) = makeSUT()
        let exp = expectation(description: "Wait for load completion")
        
        
        sut.loadImageData(from: anyURL()) { result in
            switch result {
            case let (.failure(receivedError as NSError)):
                XCTAssertEqual(receivedError, RemoteFeedImageDataLoader.Error.invalidData as NSError)
            default:
                XCTFail("Expecting failure")
            }
        }
        
        client.complete(with: 201)
        exp.fulfill()
        wait(for: [exp], timeout: 1.0)
    }
    
    private func makeSUT(url: URL = URL(string: "http://any-url.com")!, file: StaticString = #file, line: UInt = #line) -> (sut: RemoteFeedImageDataLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedImageDataLoader(client: client)
        return (sut, client)
    }
    
    func anyURL() -> URL {
        return URL(string: "http://any-url.com")!
    }
}
