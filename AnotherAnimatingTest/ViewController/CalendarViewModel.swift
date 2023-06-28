//
//  FirstViewModel.swift
//  AnotherAnimatingTest
//
//  Created by Данила Бердников on 26.06.2023.
//

import Foundation

class CalendarViewModel {

    private var years: [Int] = [Int]() {
        didSet {
            self.bindYearsViewModelToController()
        }
    }

    
    private var monthInYear: [Int:[MonthViewModel?]] = [Int:[MonthViewModel?]]() {
        didSet {
            self.bindMonthInYearsSectionViewModelToController()
        }
    }
    
    var bindMonthInYearsSectionViewModelToController : (() -> ()) = {}
    var bindYearsViewModelToController : (() -> ()) = {}

    private static var uniqueInstance: CalendarViewModel?

        private init() {        getFirstThreeYears()
}

        static func shared() -> CalendarViewModel {
            if uniqueInstance == nil {
                uniqueInstance = CalendarViewModel()
            }
            return uniqueInstance!
        }

   
    
    func getYearInSection(year: Int, isUp: Bool) {

        var myView = [MonthViewModel]()
        for month in 1...12 {
            let monhtArray = getMonthArray(for: year, month: month)
            let newModel = MonthViewModel(monthArray: monhtArray, monthName: MonthName(rawValue: month)!.name, monthYear: year)
            myView.append(newModel)
        }
        if isUp {
            years.insert(year, at: 0)
        }
        else {
            
            years.append(year)

        }
        monthInYear[year] = myView
    }

    func getSections() -> [Int] {
        years
    }
    
    func getMonths() -> [Int:[MonthViewModel?]] {
        return monthInYear
    }

    func getYearSection(complition: ([Int:[MonthViewModel?]])-> Void) {
        complition(monthInYear)
    }

    func getFirstValue() -> Int {
        guard let firstSection = years.first else { return 0 }
        return firstSection
    }

    func getLastValue() -> Int {
        guard let lastSection = years.last else { return 0 }
        return lastSection
    }
    
    func getFirstThreeYears() {
        for yea in -1...1 {
            getYearInSection(year: Calendar.current.component(.year, from: Date()) + yea, isUp: false)
        }
    }

    private func getMonthArray(for year: Int, month: Int) -> [[Int]] {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 4 * 60 * 60)!
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = 1
        let firstDayOfMonth = calendar.date(from: components)!
        var weekday = calendar.component(.weekday, from: firstDayOfMonth)
        if DateFormatter().weekdaySymbols[weekday-1] == "Sunday" {
            weekday = 8
        }
        var monthArray = [[Int]](repeating: [Int](repeating: 0, count: 7), count: 6)
        var day = 1

        for i in 0..<6 {
            for j in 0..<7 {
                if i == 0 && j < weekday - 2 {
                    continue
                }
                if day > calendar.range(of: .day, in: .month, for: firstDayOfMonth)!.count {
                    break
                }
                monthArray[i][j] = day
                day += 1
            }
        }

        return monthArray
    }

}
