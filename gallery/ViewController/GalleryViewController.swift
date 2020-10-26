//
//  ViewController.swift
//  gallery
//
//  Created by Algis on 14/10/2020.
//

import UIKit

class GalleryViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noDataLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let loader = ImageLoader()
    weak var refreshControll: UIRefreshControl!
    
    private let viewModel = GalleryViewModel(galleryService: GalleryService())
    let imageCellReuseIdentifier = "ImageTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Gallery"
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(UINib(nibName: "ImageTableViewCell", bundle: nil), forCellReuseIdentifier: imageCellReuseIdentifier)
        self.tableView.tableFooterView = UIView()
        
        setupBindings()
        setupRefreshControll()
        viewModel.fetchData()
    }
    
    private func setupRefreshControll() {
        let refreshControll = UIRefreshControl()

        tableView.refreshControl = refreshControll

        self.refreshControll = refreshControll
        self.refreshControll.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
    }
    
    @objc func refresh(sender:AnyObject)
    {
        viewModel.fetchData()
        self.tableView.refreshControl?.endRefreshing()
    }
    
    func setupBindings() {
        viewModel.reloadTableViewClosure = { [weak self] () in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        viewModel.updateLoadingStatusClosure = { [weak self] state in
            DispatchQueue.main.async {
                switch state {
                case .loading:
                    self?.activityIndicator.startAnimating()
                    self?.activityIndicator.isHidden = false
                    self?.noDataLabel.isHidden = true
                    self?.tableView.isHidden = true
                case .finished:
                    self?.activityIndicator.stopAnimating()
                    self?.activityIndicator.isHidden = true
                    self?.noDataLabel.isHidden = true
                    self?.tableView.isHidden = false
                case .empty:
                    self?.activityIndicator.stopAnimating()
                    self?.activityIndicator.isHidden = true
                    self?.noDataLabel.isHidden = false
                    self?.tableView.isHidden = true
                }
            }
        }
    }
}

extension GalleryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: imageCellReuseIdentifier, for: indexPath) as! ImageTableViewCell
        let recipe = viewModel.getData(at: indexPath)
        cell.setup(title: recipe.title)
        cell.photoImageView.loadImage(at: recipe.thumbnail)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height / 5
    }
}

