//
//  FeedTableViewCell.swift
//  NewsApp
//
//

import UIKit
import WebKit

class DefaultFeedTableViewCell: UITableViewCell {
    
    var iconImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleToFill
        image.clipsToBounds = true
        return image
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    var sourceTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        stackView.spacing = 10.0
        stackView.alignment = .fill
        return stackView
    }()
    
    private var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        stackView.spacing = 10.0
        stackView.alignment = .fill
        return stackView
    }()
    
    var didTapCell: (()-> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(mainStackView)
        stackView.addArrangedSubview(iconImageView)
        stackView.addArrangedSubview(titleLabel)
        mainStackView.addArrangedSubview(stackView)
        mainStackView.addArrangedSubview(sourceTitleLabel)
        
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            iconImageView.heightAnchor.constraint(lessThanOrEqualToConstant: 100),
            iconImageView.widthAnchor.constraint(equalToConstant: 100)
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didSelect(_:)))
        tapGesture.numberOfTapsRequired = 1
        addGestureRecognizer(tapGesture)
    }
    
    func configure(_ viewModel: DefaultFeedImageTableViewCellViewModel) {
        titleLabel.text = viewModel.article.title
        sourceTitleLabel.text = viewModel.article.source.name
        guard let urlString = viewModel.article.urlToImage , let url = URL(string: urlString) else {
            iconImageView.isHidden = true
            return
        }
        
        viewModel.loadImage(url: url) { image in
            DispatchQueue.main.async { [weak self] in
                self?.iconImageView.isHidden = false
                self?.iconImageView.image = image
            }
        }
    }
    
    @objc
    private func didSelect(_ sender: UISwipeGestureRecognizer) {
        didTapCell?()
    }
}

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>() -> T {
        let identifier = String(describing: T.self)
        return dequeueReusableCell(withIdentifier: identifier) as! T
    }
}
