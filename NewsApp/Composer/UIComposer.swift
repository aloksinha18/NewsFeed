//
//  UIComposer.swift
//  NewsApp
//
//

import Foundation
import UIKit

class UIComposer {
    private var viewControler: FeedViewController?
    
    func feedViewcontroller(feedLoader: FeedLoader, imageLoader: FeedImageDataLoader) -> UIViewController {
        let viewModel = FeedViewModel(feedLoader: feedLoader, imageLoader: imageLoader)
        let feedController = FeedViewController(viewModel:viewModel)
        
        viewModel.onFeedLoad = { [weak self] feed in
            self?.adopt(items: feed, on: feedController, imageLoader: imageLoader)
            
        }
        self.viewControler = feedController
        feedController.delegate = self
        return UINavigationController(rootViewController: feedController)
    }
    
    func adopt(items: [Article],  on controller: FeedViewController, imageLoader: FeedImageDataLoader) {
        var cellController = [CellPresetable]()
        for (index, item) in items.enumerated() {
            switch index {
            case 0:
                let largeCellController = LargeCellController(article: item, imageLoader: imageLoader)
                largeCellController.didSelectArticle = { [weak self] result in
                    guard let self = self else { return }
                    self.show(result, with: items, on: controller)
                }
                cellController.append(largeCellController)
            case 1:
                let twoCellController = TwoCellController(firstArticle: item, secondArticle: items[index + 1], imageLoader: imageLoader)
                twoCellController.didSelectArticle = { [weak self] result in
                    guard let self = self else { return }
                    self.show(result, with: items, on: controller)
                }
                cellController.append(twoCellController)
            case 2:
                let item = HTMLCellController()
                cellController.append(item)
            default:
                let defaultCellController = DefaultCellController(article: item, imageLoader: imageLoader)
                defaultCellController.didSelectArticle = { [weak self] result in
                    guard let self = self else { return }
                    self.show(result, with: items, on: controller)
                }
                cellController.append(defaultCellController)
            }
        }
        
        controller.cellControllers = cellController
    }
    
    func show(_ article: Article, with feeds: [Article], on viewController: FeedViewController) {
        let imageDataLoader = RemoteFeedImageDataLoader(client:  URLSessionHTTPClient(session: URLSession.shared))
        let index = feeds.firstIndex(of: article) ?? 0
        let newsViewModel = NewsDetailViewModel(articles: feeds, currentIndex: index, loader: imageDataLoader)
        let detailController = NewsDetailViewController(viewModel: newsViewModel)
        viewController.navigationController?.pushViewController(detailController, animated: true)
    }
}

extension UIComposer: FeedViewControllerDelegate {
    
    func didSelect(articles: [Article], at index: Int, on viewController: FeedViewController) {
        let imageDataLoader = RemoteFeedImageDataLoader(client:  URLSessionHTTPClient(session: URLSession.shared))
        let newsViewModel = NewsDetailViewModel(articles: articles, currentIndex: index, loader: imageDataLoader)
        let detailController = NewsDetailViewController(viewModel: newsViewModel)
        viewController.navigationController?.pushViewController(detailController, animated: true)
    }
}
