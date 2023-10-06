//
//  TaskViewModel.swift
//  AnotherAnimatingTest
//
//  Created by Данила Бердников on 14.07.2023.
//

import Foundation

struct TaskModel: Hashable {

    var id = Int.random(in: 0..<Int.max)

    let monthName: String
    let monthYear: Int

    init(monthName: String, monthYear: Int) {
        self.monthName = monthName
        self.monthYear = monthYear
    }

    static func == (lhs: TaskModel, rhs: TaskModel) -> Bool {
        lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
      // 2
      hasher.combine(id)
    }
}
