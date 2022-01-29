//
//  TwoFeedsTableViewCell.swift
//  NewsApp
//
//

import UIKit

class TwoFeedsTableViewCell: UITableViewCell {
    
    var firstFeedIconImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleToFill
        image.clipsToBounds = true
        return image
    }()
    
    var secondFeedIconImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleToFill
        image.clipsToBounds = true
        return image
    }()
    
    var firstFeedTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    var secondFeedTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    var firstFeedSourceTitlelLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    var secondFeedSourceTitlelLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        stackView.spacing = 10.0
        stackView.alignment = .center
        return stackView
    }()
    
    private var FirstArticleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        stackView.spacing = 10.0
        stackView.alignment = .center
        stackView.isUserInteractionEnabled = true
        return stackView
    }()
    
    private var secondArticleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        stackView.spacing = 10.0
        stackView.alignment = .center
        return stackView
    }()
    
    var didTapFirstArticle: (()-> Void)?
    var didTapSecondArticle: (()-> Void)?

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(mainStackView)
        
        FirstArticleStackView.addArrangedSubview(firstFeedIconImageView)
        FirstArticleStackView.addArrangedSubview(firstFeedTitleLabel)
        FirstArticleStackView.addArrangedSubview(firstFeedSourceTitlelLabel)

        secondArticleStackView.addArrangedSubview(secondFeedIconImageView)
        secondArticleStackView.addArrangedSubview(secondFeedTitleLabel)
        secondArticleStackView.addArrangedSubview(secondFeedSourceTitlelLabel)

        mainStackView.addArrangedSubview(FirstArticleStackView)
        mainStackView.addArrangedSubview(secondArticleStackView)

        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            firstFeedIconImageView.heightAnchor.constraint(equalToConstant: 100),
            firstFeedIconImageView.widthAnchor.constraint(equalToConstant: 100),
            
            secondFeedIconImageView.heightAnchor.constraint(equalToConstant: 100),
            secondFeedIconImageView.widthAnchor.constraint(equalToConstant: 100),
            
            firstFeedIconImageView.topAnchor.constraint(equalTo: secondFeedIconImageView.topAnchor)
        ])
        
        let firstArticleTapGesture = UITapGestureRecognizer(target: self, action: #selector(didSelectFirst(_:)))
        firstArticleTapGesture.numberOfTapsRequired = 1
        FirstArticleStackView.addGestureRecognizer(firstArticleTapGesture)
        FirstArticleStackView.isUserInteractionEnabled = true

        
        let secondArticleTapGesture = UITapGestureRecognizer(target: self, action: #selector(didSelectSecond(_:)))
        secondArticleStackView.addGestureRecognizer(secondArticleTapGesture)
        secondArticleStackView.isUserInteractionEnabled = true

        addGestureRecognizer(secondArticleTapGesture)
    }
    
    @objc private func didSelectFirst(_ sender: UISwipeGestureRecognizer) {
        didTapFirstArticle?()
    }
    
    @objc private func didSelectSecond(_ sender: UISwipeGestureRecognizer) {
        didTapSecondArticle?()
    }
    
    func configure(_ viewModel: TwoFeedTableViewCellViewModel) {
        firstFeedTitleLabel.text = viewModel.firstArticle.title
        secondFeedTitleLabel.text = viewModel.secondArticle.title
        
        firstFeedSourceTitlelLabel.text = viewModel.firstArticle.source.name
        secondFeedSourceTitlelLabel.text = viewModel.secondArticle.source.name

        if let firstFeedImgageURL = URL(string: viewModel.firstArticle.urlToImage ?? "")  {
            viewModel.loadImage(url: firstFeedImgageURL) { image in
                DispatchQueue.main.async { [weak self] in
                    self?.firstFeedIconImageView.image = image
                }
            }
        } else {
            firstFeedIconImageView.isHidden = true
        }
        
        
        if let secondFeedImageURL =  URL(string: viewModel.secondArticle.urlToImage ?? "")  {
            viewModel.loadImage(url: secondFeedImageURL) { image in
                DispatchQueue.main.async { [weak self] in
                    self?.secondFeedIconImageView.image = image
                }
            }
        }
    }
}
