//
//  FirstViewDelegate.swift
//  AnotherAnimatingTest
//
//  Created by Данила Бердников on 22.06.2023.
//

import Foundation

protocol FirstViewDelegate: AnyObject {
    /// Called when a cell is selected.
    /// - Parameter cell: The selected cell.
    func didSelectCell(cell: FirstMonthCell)
    
    /// Retrieves the first value.
    func firstValue() -> Int
    /// Retrieves information based on year and a specific condition.
    /// - Parameters:
    ///   - year: The year to be checked.
    ///   - ascendingOrder: A flag indicating if the year is in ascending order.
    func yearInSection(year: Int, ascendingOrder: Bool)
    
    /// Retrieves the year section.
    /// - Parameter completion: The completion block with a dictionary of months for each year.
//    func yearSection(completion: ([Int: [MonthModel?]]) -> Void)
    
    /// Retrieves the last value.
    func lastValue() -> Int
}

