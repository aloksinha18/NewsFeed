//
//  NewsDetailViewCellViewController.swift
//  NewsApp
//
//

import UIKit

class NewsDetailViewController: UIViewController {
    
    var iconImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
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
    
    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        stackView.spacing = 40.0
        stackView.alignment = .center
        return stackView
    }()
    
    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var viewModel: NewsDetailViewModel
    private weak var imageHeight: NSLayoutConstraint?
    init(viewModel: NewsDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        self.view.addSubview(scrollView)
        
        scrollView.addSubview(stackView)
        view.backgroundColor = .white
        stackView.addArrangedSubview(iconImageView)
        stackView.addArrangedSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 64),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -16),
            
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16),
            iconImageView.widthAnchor.constraint(equalTo: stackView.widthAnchor),
        ])
        setUpImageViewHeight()
        titleLabel.text = viewModel.title
        loadImage()
        
        viewModel.onSwipeCompletion = { [weak self] article in
            guard let self  = self else { return }
            self.titleLabel.text = article.title
            self.loadImage()
        }
        
        let leftEwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(_:)))
        leftEwipeGestureRecognizer.direction = .left
        
        let rightSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(_:)))
        rightSwipeGestureRecognizer.direction = .right
        
        view.addGestureRecognizer(leftEwipeGestureRecognizer)
        view.addGestureRecognizer(rightSwipeGestureRecognizer)
    }
    
    private func setUpImageViewHeight() {
        imageHeight = iconImageView.heightAnchor.constraint(equalToConstant: 0.0)
        imageHeight?.isActive = true
    }
    
    @objc private func didSwipe(_ sender: UISwipeGestureRecognizer) {
        switch sender.direction {
            
        case .right:
            if viewModel.canSwiftRight() {
                reset()
                viewModel.swipeRight()
            }
        case .left:
            if viewModel.canSwiftLeft() {
                reset()
                viewModel.swipeLeft()
            }
        default:
            debugPrint("No action needed")
        }
    }
    
    private func reset() {
        titleLabel.text = ""
        iconImageView.image = nil
    }
    
    func loadImage() {
        viewModel.loadImage { data in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                if let data = data, let image = UIImage(data: data) {
                    self.updateDataWithAnimation(image)
                } else {
                    self.updateImageHeightViewConstarints()
                }
            }
        }
    }
    
    
    private func updateDataWithAnimation(_ image : UIImage) {
        UIView.transition(with: self.iconImageView,
                                  duration: 1.0,
                                  options: .transitionCrossDissolve,
                          animations: {
            self.iconImageView.image = image
            self.updateImageHeightViewConstarints(image: image)
        }, completion: nil)
    }
    
    func updateImageHeightViewConstarints(image: UIImage? = nil) {
        guard image != nil else {
            imageHeight?.constant = 0.0
            return
        }
        
        imageHeight?.constant = iconImageView.getAspectFitHeight(image: image)
    }
}

private extension UIImageView {
    func getAspectFitHeight(image: UIImage?) -> CGFloat {
        guard let image = image else { return 0.0 }
        let ratio =  image.size.width / image.size.height
        return self.frame.width / ratio
    }
}
