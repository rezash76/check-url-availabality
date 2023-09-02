//
//  HomeViewModel.swift
//  Check URL availablity
//
//  Created by Reza Sharifi on 9/1/23.
//

import Foundation

class HomeViewModel {
    
    let repository: UrlRepository = UrlRepositoryImpl()
    var urlModels = [UrlModel]()
    
    public enum homeError {
        case internetError (String)
        case serverMessage (String)
    }
    
    public var onUrlModels: (([UrlModel]) -> Void)?
    public var loading: ((Bool) -> Void)?
    public var onError: ((homeError) -> Void)?
    
    
    func checkAvailablity(of url: String) {
        self.loading?(true)
        repository.checkAvailablity(of: url) { model in
            DispatchQueue.main.async {
                self.urlModels.append(model)
                self.loading?(false)
                self.onUrlModels?(self.urlModels)
            }
        }
    }
    
    
    func getAllCheckedUrls() {
        repository.getAllCheckedUrls { models in
            self.urlModels.removeAll()
            self.urlModels.append(contentsOf: models)
            self.onUrlModels?(self.urlModels)
        }
        
    }
    
    func checkAvailablityOf(all urls: [String]) {
        repository.checkAvailablityOf(all: urls) { models in
            self.urlModels.removeAll()
            self.urlModels.append(contentsOf: models)
            self.onUrlModels?(self.urlModels)
        }
    }
    
    func delete(url: UrlModel) {
        repository.delete(url: url)
    }
    
    func sortBy(option: SortOption) {
        option.save()
        urlModels.sortBy(option: option)
        onUrlModels?(urlModels)
    }
}
