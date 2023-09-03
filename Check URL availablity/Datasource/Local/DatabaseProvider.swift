//
//  DatabaseProvider.swift
//  Check URL availablity
//
//  Created by Reza Sharifi on 9/1/23.
//

import Foundation

protocol DataBaseProvider {
    func add(data: UrlModel)
    func getAllData() -> [UrlModel]
    func delete(data: UrlModel)
}

class DatabaseManager: DataBaseProvider {
    func add(data: UrlModel) {
        RealmManager.shared.add(url: data)
    }
    
    func getAllData() -> [UrlModel] {
        RealmManager.shared.getAll()
    }
    
    func delete(data: UrlModel) {
        RealmManager.shared.delete(url: data)
    }
    
}

