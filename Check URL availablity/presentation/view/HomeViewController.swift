//
//  ListOfURLsViewController.swift
//  Check URL availablity
//
//  Created by Reza Sharifi on 9/1/23.
//

import UIKit
import Toast

class HomeViewController: UIViewController, loadingViewable {
    
    lazy var refreshBarButton: UIBarButtonItem = {
        var button = UIBarButtonItem(image: UIImage(systemName: "arrow.clockwise"), style: .plain, target: self, action: #selector(refreshTapped))
        return button
    }()
    
    lazy var addURLBarButton: UIBarButtonItem = {
        var button = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addURLTapped))
        return button
    }()
    
    lazy var sortBarButton: UIBarButtonItem = {
        var button = UIBarButtonItem(image: UIImage(systemName: "list.bullet"), style: .plain, target: self, action: #selector(sortButtonTapped))
        return button
    }()
    
    lazy var searchController: UISearchController = {
        var controller = UISearchController()
        controller.searchResultsUpdater = self
        controller.searchBar.sizeToFit()
        controller.searchBar.showsCancelButton = true
        controller.searchBar.tintColor = .white
        controller.searchBar.delegate = self
        controller.searchBar.barTintColor = .black
        controller.searchBar.searchTextField.textColor = .black
        controller.searchBar.searchTextField.keyboardType = .URL
        controller.searchBar.searchTextField.backgroundColor = .white
        return controller
    }()
    
    lazy var urlTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isEditing = false
        tableView.allowsSelection = true
        tableView.separatorStyle = .singleLine
        tableView.register(UrlTableViewCell.self, forCellReuseIdentifier: "urlCell")
        return tableView
    }()
    
    
    // MARK: - Properties
    
    var urlModels = [UrlModel]() {
        didSet {
            urlTableView.reloadData()
        }
    }
    
    var searchResults = [UrlModel]() {
        didSet {
            urlTableView.reloadData()
        }
    }
    
    var homeViewModel = HomeViewModel()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "List of URLs"
        navigationItem.rightBarButtonItems = [refreshBarButton, addURLBarButton]
        navigationItem.leftBarButtonItem = sortBarButton
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        addViews()
        setupConstraint()
        setupBindings()
        homeViewModel.getAllCheckedUrls()
    }
    
    func addViews() {
        view.addSubview(urlTableView)
    }
    
    func setupConstraint() {
        NSLayoutConstraint.activate([
            urlTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            urlTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            urlTableView.topAnchor.constraint(equalTo: view.topAnchor),
            urlTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc private func refreshTapped() {
        let urls = self.urlModels.map { $0.url }
        homeViewModel.checkAvailablityOf(all: urls)
    }
    
    @objc private func addURLTapped() {
        let ac = UIAlertController(title: "Type a Url to check availablity.", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.textFields?.first?.keyboardType = .URL
        ac.addAction(UIAlertAction(title: "Check", style: .default) { [unowned ac] _ in
            let text = ac.textFields?.first?.text
            if let text {
                let model = UrlModel(url: text, isAvailable: false, isChecking: true)
                self.urlModels.append(model)
                if let opton = UserDefaultStore.shared.getSortOption() {
                    switch opton {
                    case .name(_):
                        self.urlModels.sortBy(option: opton)
                    default:
                        break
                    }
                }
                self.homeViewModel.addUrlToCheck(text)
            }
        }
        )
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }
    
    @objc private func sortButtonTapped() {
        showSortOptions()
    }
    
    func showSortOptions() {
        let alert = UIAlertController(title: "Sorting", message: "You can sort the list by:", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Name ascending", style: .default , handler:{ (UIAlertAction) in
            self.homeViewModel.sortBy(option: .name(isAscending: true))
        }))
        
        alert.addAction(UIAlertAction(title: "Name descending", style: .default , handler:{ (UIAlertAction) in
            self.homeViewModel.sortBy(option: .name(isAscending: false))
        }))
        
        alert.addAction(UIAlertAction(title: "availability", style: .default , handler:{ (UIAlertAction) in
            self.homeViewModel.sortBy(option: .availability)
        }))
        
        alert.addAction(UIAlertAction(title: "Response time ascending", style: .default, handler:{ (UIAlertAction) in
            self.homeViewModel.sortBy(option: .checkingTime(isAscending: true))
        }))
        
        alert.addAction(UIAlertAction(title: "Response time descending", style: .default, handler:{ (UIAlertAction) in
            self.homeViewModel.sortBy(option: .checkingTime(isAscending: false))
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        self.present(alert, animated: true)
    }
    
    func setupBindings() {
        
        homeViewModel.loading = { [weak self] (isLoading) in
            guard let `self` = self else {return}
            isLoading ? self.startLoading() : self.stopLoading()
        }
        
        homeViewModel.onUrlModels = { [weak self] (models) in
            guard let `self` = self else {return}
            urlModels = models
        }
        
        homeViewModel.onSearchedUrls = { [weak self] (models) in
            guard let `self` = self else {return}
            searchResults = models
        }
    }
}

// MARK: - TableView Delegate and DataSource
extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchController.isActive ? searchResults.count : urlModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "urlCell", for: indexPath) as! UrlTableViewCell
        
        let url = searchController.isActive ? searchResults[indexPath.row] : urlModels[indexPath.row]
        cell.urlModel = url
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchController.isActive = false
    }
}

extension HomeViewController {
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let url = urlModels[indexPath.row]
            if url.isChecking {
                self.view.makeToast("Please wait untill the end of process.")
            } else {
                self.homeViewModel.delete(url: url)
                self.urlModels.remove(at: indexPath.row)
            }
        }
    }
}

// MARK: - SearchBar Delegate and Search Results Updatings
extension HomeViewController: UISearchBarDelegate, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchString = searchController.searchBar.text!
        self.homeViewModel.filterResultsWith(searchingUrl: searchString)
        if !self.searchController.isFirstResponder {
            self.searchController.becomeFirstResponder()
        }
    }
}
