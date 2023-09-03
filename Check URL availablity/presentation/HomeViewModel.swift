//
//  HomeViewModel.swift
//  Check URL availablity
//
//  Created by Reza Sharifi on 9/1/23.
//

import Foundation

class HomeViewModel {
    
    public enum homeError {
        case internetError(String)
        case serverMessage(String)
    }
    
    
    
    private let repository: UrlRepository = UrlRepositoryImpl()
    private var urlModels = [UrlModel]()
    
    public var onUrlModels: (([UrlModel]) -> Void)?
    public var loading: ((Bool) -> Void)?
    public var onError: ((homeError) -> Void)?
    
    
    func addUrlToCheck(_ url: String) {
//        self.loading?(true)
        repository.checkAvailablity(of: url) { model in
            DispatchQueue.main.async {
                self.urlModels.append(model)
                if let option = readSortOption() {
                    self.urlModels.sortBy(option: option)
                }
//                self.loading?(false)
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
        if url.isChecking {
//            onError?()
        } else {
            repository.delete(url: url)
        }
        
    }
    
    func sortBy(option: SortOption) {
        option.save()
        urlModels.sortBy(option: option)
        onUrlModels?(urlModels)
    }
}





func readSortOption() -> SortOption? {
    let userDefaults = UserDefaults.standard
    
    if let rawDictionary = userDefaults.dictionary(forKey: "sortOption"),
       let dictData = try? JSONSerialization.data(withJSONObject: rawDictionary)
    {
        return try? JSONDecoder().decode(SortOption.self, from: dictData)
    } else {
        return nil
    }
}
