//
//  DatabaseProvider.swift
//  Check URL availablity
//
//  Created by Reza Sharifi on 9/1/23.
//

import Foundation

protocol DataBaseProvider {
    func getAllData() -> [UrlModel]
    func getSearched(data: String) -> [UrlModel]
    func add(data: UrlModel)
    func delete(data: UrlModel)
}

class DatabaseManager: DataBaseProvider {
    
    func getAllData() -> [UrlModel] {
        RealmManager.shared.getAll()
    }
    
    func getSearched(data: String) -> [UrlModel] {
        RealmManager.shared.getFiltered(url: data)
    }
    
    func add(data: UrlModel) {
        RealmManager.shared.add(url: data)
    }
    
    func delete(data: UrlModel) {
        RealmManager.shared.delete(url: data)
    }
}

