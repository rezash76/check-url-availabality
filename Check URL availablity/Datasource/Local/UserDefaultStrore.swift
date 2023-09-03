//
//  UserDefualtStrore.swift
//  Check URL availablity
//
//  Created by Reza Sharifi on 9/3/23.
//

import Foundation

class UserDefaultStore {
    
    enum DefaultsKey: String {
        case sortOption = "sortOption"
    }
    
    static let shared = UserDefaultStore()
    
    private let defaults = UserDefaults.standard
    
    // domain
    func setSortOption(option: SortOption) {
        if let data = try? JSONEncoder().encode(option),
           let dict = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
        {
            defaults.set(dict, forKey: DefaultsKey.sortOption.rawValue)
        }
    }
    
    func getSortOption() -> SortOption? {
        if let rawDictionary = defaults.dictionary(forKey: DefaultsKey.sortOption.rawValue),
           let dictData = try? JSONSerialization.data(withJSONObject: rawDictionary) {
            return try? JSONDecoder().decode(SortOption.self, from: dictData)
        } else {
            return nil
        }
    }
    
    
}
