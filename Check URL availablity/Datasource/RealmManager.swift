//
//  RealmManager.swift
//  Check URL availablity
//
//  Created by Reza Sharifi on 9/2/23.
//

import Foundation
import RealmSwift

class RealmManager {
    
    static let shared = RealmManager()
    private let realm: Realm
    
    init() {
        self.realm = try! Realm(queue: DispatchQueue.main)
    }
    
    func getAll() -> [UrlModel] {
        realm.objects(UrlModel.self).toArray()
    }
    
    func add(url: UrlModel) {
        try! realm.write {
            realm.add(url)
        }
    }
    
    func delet(url: UrlModel) {
        try! realm.write {
            realm.delete(url)
        }
    }
}

extension Results {
    func toArray() -> [Element] {
        return self.map{$0}
    }
}
