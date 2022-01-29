//
//  HTMLFeedTableViewCell.swift
//  NewsApp
//
//

import UIKit
import WebKit

class HTMLFeedTableViewCell: UITableViewCell {
    
    var webView: WKWebView  = {
        let webview = WKWebView()
        webview.contentMode = .scaleToFill
        webview.translatesAutoresizingMaskIntoConstraints = false
        return webview
    }()
    
    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        stackView.spacing = 10.0
        stackView.alignment = .center
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(webView)
        webView.navigationDelegate = self
        
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            webView.topAnchor.constraint(equalTo: contentView.topAnchor),
            webView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            webView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor),
            webView.heightAnchor.constraint(equalToConstant: 100),
        ])
    }
    
    func configure(_ viewModel: HTMLFeedTableViewCellViewModel) {
        webView.loadHTMLString(viewModel.htmlString, baseURL: nil)
    }
}

extension HTMLFeedTableViewCell: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        switch navigationAction.navigationType {
        case .linkActivated:
            let url = navigationAction.request.url
            UIApplication.shared.open(url!)
            decisionHandler(.cancel)
        default:
            decisionHandler(.allow)
        }
    }
}
