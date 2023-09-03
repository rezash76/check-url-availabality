//
//  UrlRepositoryImpl.swift
//  Check URL availablity
//
//  Created by Reza Sharifi on 9/1/23.
//

import Foundation

struct UrlRepositoryImpl: UrlRepository {
    
    let apiProvider: ApiProvider = ApiManager()
    let dbProvider: DataBaseProvider = DatabaseManager()
    
    func getAllCheckedUrls(callBack: @escaping ([UrlModel]) -> ()) {
        var urlModels = dbProvider.getAllData()
        if let option = readSortOption() {
            urlModels.sortBy(option: option)
        }
        
        callBack(urlModels)
    }
    
    func checkAvailablityOf(all urls: [String], completion: @escaping ([UrlModel]) -> ()) {
        let group = DispatchGroup()
        var models = [UrlModel]()
        for url in urls {
            group.enter()
            let startTime = Date()
            let model = UrlModel()
            model.url = url
            apiProvider.get(from: url) { result in
                
                let checkingTime = Date().timeIntervalSince(startTime)
                
                model.isChecking = false
                model.checkingTime = checkingTime.rounded(toPlaces: 2)
                
                switch result {
                case .success(_):
                    model.isAvailable = true
                case let .failure(error):
                    print(error)
                    model.isAvailable = false
                    
                }
                models.append(model)
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            if let option = readSortOption() {
                models.sortBy(option: option)
            }
            completion(models)
        }
        
    }
    
    func checkAvailablity(of url: String, callBack: @escaping (UrlModel) -> ()) {
        let model = UrlModel()
        let startTime = Date()
        model.url = url
        apiProvider.get(from: url) { result in
            
            let checkingTime = Date().timeIntervalSince(startTime)
            
            model.checkingTime = checkingTime.rounded(toPlaces: 2)
            model.isChecking = false
            
            switch result {
            case .success(_):
                model.isAvailable = true
            case let .failure(error):
                print(error)
                model.isAvailable = false
            }
            
            callBack(model)
            
            DispatchQueue.main.async {
                self.dbProvider.add(data: model)
            }
        }
    }
    
    func delete(url: UrlModel) {
        DispatchQueue.main.async {
            self.dbProvider.delete(data: url)
        }
    }
    
//    func readSortOption() -> SortOption? {
//        let userDefaults = UserDefaults.standard
//
//        if let rawDictionary = userDefaults.dictionary(forKey: "sortOption"),
//           let dictData = try? JSONSerialization.data(withJSONObject: rawDictionary)
//        {
//            return try? JSONDecoder().decode(SortOption.self, from: dictData)
//        } else {
//            return nil
//        }
//    }
}
