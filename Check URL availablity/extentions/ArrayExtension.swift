//
//  ArrayExtension.swift
//  Check URL availablity
//
//  Created by Reza Sharifi on 9/2/23.
//

import Foundation

extension Array where Element: UrlModel {
    
    mutating func sortBy(option: SortOption) {
        switch option {
        case let .name(isAscending):
            if isAscending {
                sort(by: {$0.url < $1.url})
            } else {
                sort(by: {$0.url > $1.url})
            }
        case .availability:
            sort(by: { $0.isAvailable && !$1.isAvailable })
        case let .checkingTime(isAscending):
            if isAscending {
                sort(by: {$0.checkingTime < $1.checkingTime})
            } else {
                sort(by: {$0.checkingTime > $1.checkingTime})
            }
        }
    }
}
