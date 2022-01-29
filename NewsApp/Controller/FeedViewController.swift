//
//  ViewController.swift
//  NewsApp
//
//

import UIKit

protocol FeedViewControllerDelegate: AnyObject {
    func didSelect(articles: [Article], at index: Int, on viewController: FeedViewController)
}

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var table: UITableView = UITableView()
    private var refreshView: UIRefreshControl = UIRefreshControl()
    
    private var viewModel: FeedViewModel
    weak var delegate: FeedViewControllerDelegate?
    
    var cellControllers = [CellPresetable]() {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.table.reloadData()
            }
        }
    }
        
    init(viewModel: FeedViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupTableView()
        refresh()
        refreshView.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    private func setupTableView() {
        
        table.register(LargeFeedImageTableViewCell.self, forCellReuseIdentifier: "LargeFeedImageTableViewCell")
        table.register(TwoFeedsTableViewCell.self, forCellReuseIdentifier: "TwoFeedsTableViewCell")
        table.register(DefaultFeedTableViewCell.self, forCellReuseIdentifier: "DefaultFeedTableViewCell")
        table.register(HTMLFeedTableViewCell.self, forCellReuseIdentifier: "HTMLFeedTableViewCell")
        
        view.backgroundColor = .white
        
        table.translatesAutoresizingMaskIntoConstraints = false
        table.estimatedRowHeight = UITableView.automaticDimension
        table.estimatedRowHeight = 44
        table.separatorStyle = .none
        table.refreshControl = refreshView
        table.separatorStyle = .singleLine
        
        view.addSubview(table)
        
        NSLayoutConstraint.activate([
            table.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            table.topAnchor.constraint(equalTo: view.topAnchor),
            table.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            table.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        table.delegate = self
        table.dataSource = self
    }
    
    @objc
    func refresh() {
        viewModel.refresh()
        
        viewModel.onLoadingStateChange = { [weak refreshView] isLoading in
            DispatchQueue.main.async {
                if isLoading {
                    refreshView?.beginRefreshing()
                } else {
                    refreshView?.endRefreshing()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellControllers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellControllers[indexPath.row].view(for: indexPath, tableView: tableView)
    }
}


