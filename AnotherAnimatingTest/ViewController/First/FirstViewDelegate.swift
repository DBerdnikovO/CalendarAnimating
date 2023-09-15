//
//  FirstViewDelegate.swift
//  AnotherAnimatingTest
//
//  Created by Данила Бердников on 22.06.2023.
//

import Foundation

protocol FirstViewDelegate: AnyObject {
    func didSelectCell(cell: FirstMonthCell)
    func getFirstValue() -> Int
    func getYearInSection(year: Int, isUp: Bool) 
    func getYearSection(complition: ([Int:[MonthViewModel?]])-> Void)
    func getLastValue() -> Int
}

