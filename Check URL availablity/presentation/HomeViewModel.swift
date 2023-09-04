//
//  HomeViewModel.swift
//  Check URL availablity
//
//  Created by Reza Sharifi on 9/1/23.
//

import Foundation

class HomeViewModel {
    
    private let repository: UrlRepository = UrlRepositoryImpl()
    private var urlModels = [UrlModel]()
    private var searchResults = [UrlModel]()
    
    public var onUrlModels: (([UrlModel]) -> Void)?
    public var onSearchedUrls: (([UrlModel]) -> Void)?
    public var loading: ((Bool) -> Void)?
    
    func addUrlToCheck(_ url: String) {
        repository.checkAvailablity(of: url) { model in
            DispatchQueue.main.async {
                self.urlModels.append(model)
                if let option = UserDefaultStore.shared.getSortOption() {
                    self.urlModels.sortBy(option: option)
                }
                self.onUrlModels?(self.urlModels)
            }
        }
    }
    
    
    func getAllCheckedUrls() {
        self.loading?(true)
        repository.getAllCheckedUrls { models in
            self.urlModels.removeAll()
            self.urlModels.append(contentsOf: models)
            self.onUrlModels?(self.urlModels)
            self.loading?(false)
        }
        
    }
    
    func checkAvailablityOf(all urls: [String]) {
        self.loading?(true)
        repository.checkAvailablityOf(all: urls) { models in
            self.urlModels.removeAll()
            self.urlModels.append(contentsOf: models)
            self.onUrlModels?(self.urlModels)
            self.loading?(false)
        }
    }
    
    func delete(url: UrlModel) {
        repository.delete(url: url)
    }
    
    func filterResultsWith(searchingUrl url: String) {
        let searchUrls = repository.getSearchedUrls(with: url)
        searchResults.removeAll()
        searchResults.append(contentsOf: searchUrls)
        onSearchedUrls?(searchResults)
    }
    
    func sortBy(option: SortOption) {
        UserDefaultStore.shared.setSortOption(option: option)
        urlModels.sortBy(option: option)
        onUrlModels?(urlModels)
    }
}
