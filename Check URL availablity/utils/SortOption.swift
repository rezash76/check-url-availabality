//
//  SortOption.swift
//  Check URL availablity
//
//  Created by Reza Sharifi on 9/2/23.
//

import Foundation

enum SortOption: Codable {
    case name(isAscending: Bool)
    case availability
    case checkingTime(isAscending: Bool)
}

extension SortOption {
    
    func save() {
        let userDefaults = UserDefaults.standard
        
        if let data = try? JSONEncoder().encode(self),
           let dict = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
        {
            userDefaults.set(dict, forKey: "sortOption")
        }
    }
}
