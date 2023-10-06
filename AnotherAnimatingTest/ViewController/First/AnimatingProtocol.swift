//
//  FirstViewDelegate.swift
//  AnotherAnimatingTest
//
//  Created by Данила Бердников on 22.06.2023.
//

import Foundation

protocol AnimatingProtocol: AnyObject {

    /// Retrieves the first value.
    func firstValue() -> Int
    /// Retrieves information based on year and a specific condition.
    /// - Parameters:
    ///   - year: The year to be checked.
    ///   - ascendingOrder: A flag indicating if the year is in ascending order.
    func yearInSection(year: Int, ascendingOrder: Bool)
    
    
    /// Retrieves the last value.
    func lastValue() -> Int
    
    func monthInSection(section: Int) -> [MonthModel?]
}

