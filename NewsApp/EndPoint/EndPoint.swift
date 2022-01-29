//
//  EndPoint.swift
//  NewsApp
//
//

import Foundation

enum Endpoint {
    
    case country(_ code: String)
    
    var url: URL? {
        var components = URLComponents()
        let base: String = "newsapi.org"
        components.scheme = "https"
        components.host = base
        components.path = path
        components.queryItems = queryItems
        return components.url
    }
    
    var path: String {
        switch self {
        case .country:
            return "/v2/top-headlines"
        }
    }
    
    private var queryItems: [URLQueryItem] {
        
        var queryItems = [URLQueryItem]()
        
        switch self {
        case .country(let code):
            queryItems.append(URLQueryItem(name: "country", value: code))
        }
        
        queryItems.append(URLQueryItem(name: "apiKey", value: "bdc338f69bb84a38a6bf3f22f21585f8"))
        return queryItems
    }
}
