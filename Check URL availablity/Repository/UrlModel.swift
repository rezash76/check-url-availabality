//
//  UrlModel.swift
//  Check URL availablity
//
//  Created by Reza Sharifi on 9/1/23.
//

import Foundation
import RealmSwift

class UrlModel: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var url: String
    @Persisted var isAvailable: Bool
    @Persisted var isChecking: Bool
    @Persisted var checkingTime: Double
    
    convenience init(url: String, isAvailable: Bool, isChecking: Bool = false, checkingTime: Double = 0) {
        self.init()
        self.url = url
        self.isAvailable = isAvailable
        self.isChecking = isChecking
        self.checkingTime = checkingTime
    }
}
