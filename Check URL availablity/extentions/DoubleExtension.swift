//
//  DoubleExtension.swift
//  Check URL availablity
//
//  Created by Reza Sharifi on 9/2/23.
//

import Foundation

extension Double {
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
