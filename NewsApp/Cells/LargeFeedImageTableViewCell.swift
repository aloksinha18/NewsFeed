//
//  LargeFeedImageTableViewCell.swift
//  NewsApp
//
//

import UIKit


class LargeFeedImageTableViewCell: UITableViewCell {
    
    var iconImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleToFill
        image.clipsToBounds = true
        return image
    }()
    
    var title: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    var sourceTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        stackView.spacing = 10.0
        stackView.alignment = .leading
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
        contentView.addSubview(stackView)
        
        stackView.addArrangedSubview(iconImageView)
        stackView.addArrangedSubview(title)
        stackView.addArrangedSubview(sourceTitle)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            iconImageView.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            iconImageView.heightAnchor.constraint(equalTo: iconImageView.widthAnchor, multiplier: 9.0/16.0)
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didSelect(_:)))
        tapGesture.numberOfTapsRequired = 1
        addGestureRecognizer(tapGesture)
    }
    
    func configure(_ viewModel: DefaultFeedImageTableViewCellViewModel) {
        title.text = viewModel.article.title
        sourceTitle.text = viewModel.article.source.name
        guard let url = URL(string: viewModel.article.urlToImage ?? "") else {
            iconImageView.isHidden = true
            return
        }
        
        viewModel.loadImage(url: url) { image in
            DispatchQueue.main.async { [weak self] in
                self?.iconImageView.image = image
            }
        }
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
    }
    
    @objc private func didSelect(_ sender: UISwipeGestureRecognizer) {
        didTapCell?()
    }
}
