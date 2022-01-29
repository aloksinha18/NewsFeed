//
//  CellControllers.swift
//  NewsApp
//
//  Created by Alok Sinha on 2022-01-27.
//

import Foundation
import UIKit

protocol CellPresetable {
    func view(for indexPath: IndexPath, tableView: UITableView) -> UITableViewCell
}

class TwoCellController: CellPresetable {
    
    private let firstArticle: Article
    private let secondArticle: Article

    private let imageLoader: FeedImageDataLoader
    var didSelectArticle:((Article) -> Void)?

    init(firstArticle: Article, secondArticle: Article, imageLoader: FeedImageDataLoader) {
        self.firstArticle = firstArticle
        self.secondArticle = secondArticle
        self.imageLoader = imageLoader
    }
    
    func view(for indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        return bindedLargeFeedImageTableViewCell(tableView.dequeueReusableCell(), at: indexPath.row)
    }
    
    private func bindedLargeFeedImageTableViewCell(_ cell: TwoFeedsTableViewCell, at index: Int) -> TwoFeedsTableViewCell {
        cell.configure(TwoFeedTableViewCellViewModel(firstArticle: firstArticle, secondArticle: secondArticle, imageLoader: imageLoader))
        cell.didTapFirstArticle = selectFirstArticle
        cell.didTapSecondArticle = selectSecondArticle
        return cell
    }
    
    func selectFirstArticle() {
        didSelectArticle?(firstArticle)
    }
    
    func selectSecondArticle() {
        didSelectArticle?(secondArticle)
    }
}

class LargeCellController: CellPresetable {
    
    private let article: Article
    private var largeFeedImageTableViewCell: LargeFeedImageTableViewCell?
    private let imageLoader: FeedImageDataLoader
    var didSelectArticle:((Article) -> Void)?

    init(article: Article, imageLoader: FeedImageDataLoader) {
        self.article = article
        self.imageLoader = imageLoader
    }
    func view(for indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        return bindedLargeFeedImageTableViewCell(tableView.dequeueReusableCell(), at: indexPath.row)
    }
    
    private func bindedLargeFeedImageTableViewCell(_ cell: LargeFeedImageTableViewCell, at index: Int) -> LargeFeedImageTableViewCell {
        self.largeFeedImageTableViewCell = cell
        cell.configure(DefaultFeedImageTableViewCellViewModel(article: article, imageLoader: imageLoader))
        cell.didTapCell = selectArticle
        return cell
    }
    
    func selectArticle() {
        didSelectArticle?(article)
    }
}

class DefaultCellController: CellPresetable {
    
    private let article: Article
    private var defaultFeedTableViewCell: DefaultFeedTableViewCell?
    private let imageLoader: FeedImageDataLoader
    var didSelectArticle:((Article) -> Void)?

    init(article: Article, imageLoader: FeedImageDataLoader) {
        self.article = article
        self.imageLoader = imageLoader
    }
    func view(for indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        return bindedDefaultFeedTableViewCell(tableView.dequeueReusableCell(), at: indexPath.row)
    }
    
    private func bindedDefaultFeedTableViewCell(_ cell: DefaultFeedTableViewCell, at index: Int) -> DefaultFeedTableViewCell {
        self.defaultFeedTableViewCell = cell
        cell.configure(DefaultFeedImageTableViewCellViewModel(article: article, imageLoader: imageLoader))
        cell.didTapCell = selectArticle
        return cell
    }
    
    func selectArticle() {
        didSelectArticle?(article)
    }
}

class HTMLCellController: CellPresetable {
    
    private var htmlFeedTableViewCell: HTMLFeedTableViewCell?
    
    static let htmlString = "<div class=\"widget\"style=\"margin: .5em 0;\">\n <a href=\"https://m.gva.be/tag/coronavirus?origin=app\">\n <img alt=\"alternate\" src=\"https://static.gva.be/Assets/Images_Upload/2020/03/26/fifitent.jpg\"</div>"
    func view(for indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        return bindedHTMLFeedTableViewCell(tableView.dequeueReusableCell(), at: indexPath.row)
    }
    
    private func bindedHTMLFeedTableViewCell(_ cell: HTMLFeedTableViewCell, at index: Int) -> HTMLFeedTableViewCell {
        self.htmlFeedTableViewCell = cell
        cell.configure(HTMLFeedTableViewCellViewModel(htmlString: HTMLCellController.htmlString))
        return cell
    }
}

