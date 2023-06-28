//
//  CalendarModel.swift
//  AnotherAnimatingTest
//
//  Created by Данила Бердников on 26.06.2023.
//

import Foundation

struct MonthViewModel: Hashable {

    var id = Int.random(in: 0..<Int.max)

    let monthArray: [[Int]]
    let monthName: String
    let monthYear: Int

    init(monthArray: [[Int]], monthName: String, monthYear: Int) {
        self.monthArray = monthArray
        self.monthName = monthName
        self.monthYear = monthYear

    }

    static func == (lhs: MonthViewModel, rhs: MonthViewModel) -> Bool {
        lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
      // 2
      hasher.combine(id)
    }
}
