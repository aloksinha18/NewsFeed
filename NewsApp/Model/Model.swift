//
//  Model.swift
//  NewsApp
//
//

import Foundation

struct Root: Codable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}

// MARK: - Article
struct Article: Codable, Equatable {
    static func == (lhs: Article, rhs: Article) -> Bool {
        lhs.source.id == rhs.source.id && lhs.author == rhs.author && lhs.title == rhs.title && lhs.articleDescription == rhs.articleDescription && lhs.url == rhs.url && lhs.urlToImage == rhs.urlToImage && lhs.publishedAt == rhs.publishedAt && lhs.content == rhs.content
    }
    
    let source: Source
    let author: String?
    let title: String
    let articleDescription: String?
    let url: String
    let urlToImage: String?
    let publishedAt: String
    let content: String?
    
    enum CodingKeys: String, CodingKey {
        case source, author, title
        case articleDescription = "description"
        case url, urlToImage, publishedAt, content
    }
}

// MARK: - Source
struct Source: Codable {
    let id: String?
    let name: String
}
