//
//  ListOfURLsViewController.swift
//  Check URL availablity
//
//  Created by Reza Sharifi on 9/1/23.
//

import UIKit
import Toast

class HomeViewController: UIViewController, loadingViewable {
    
    lazy var messageView: UIView = {
        var view = UIView(frame: CGRect(x: 22, y: self.view.frame.size.width / 2, width: self.view.frame.size.width / 2, height: 40))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .gray.withAlphaComponent(0.5)
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.text = "You can not remove the URL while checking..."
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            label.topAnchor.constraint(equalTo: view.topAnchor),
            label.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        return view
    }()
    
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
    
    var homeViewModel = HomeViewModel()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "List of URLs"
        navigationItem.rightBarButtonItems = [refreshBarButton, addURLBarButton]
        navigationItem.leftBarButtonItem = sortBarButton
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
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        urlModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "urlCell", for: indexPath) as! UrlTableViewCell
        
        cell.urlModel = urlModels[indexPath.row]
        
        return cell
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
                self.view.makeToast("Pls wait untill the end of process.")
            } else {
                self.urlModels.remove(at: indexPath.row)
                self.homeViewModel.delete(url: url)
            }
        }
    }
}
