//
//  Date.swift
//  BabyProduct
//
//  Created by Artem Kupriianets on 23.06.2021.
//

import Foundation

extension Date {
    
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
    
}
