//
//  FirstViewModel.swift
//  AnotherAnimatingTest
//
//  Created by Данила Бердников on 26.06.2023.
//

import Foundation

class CalendarViewModel {

    // MARK: - Properties
    private static var uniqueInstance: CalendarViewModel?
    let currentMonth = Calendar.current.component(.month, from: Date())
    let currentYear = Calendar.current.component(.year, from: Date())

    
    private var years: [Int] = [] {
        didSet {
            bindYearsViewModelToController()
        }
    }

    private var monthInYear: [Int: [MonthModel?]] = [:] {
        didSet {
            bindMonthInYearsSectionViewModelToController()
        }
    }
    
    var bindMonthInYearsSectionViewModelToController: (() -> ()) = {}
    var bindYearsViewModelToController: (() -> ()) = {}

    static func shared() -> CalendarViewModel {
                if uniqueInstance == nil {
                    uniqueInstance = CalendarViewModel()
                }
                return uniqueInstance!
            }

    private init() {
        getInitialYears()
    }

    // MARK: - Public Methods
    
    func getYearSections() -> [Int] {
        return years
    }
    
    func getMonths() -> [Int: [MonthModel?]] {
        return monthInYear
    }

    func getMonthInSection(year: Int) -> [MonthModel?] {
        guard let months = monthInYear[year] else { return [nil]}
        return months
    }

    func getFirstYearValue() -> Int {
        return years.first ?? 0
    }

    func getLastYearValue() -> Int {
        return years.last ?? 0
    }
    
    func fetchYear(year: Int, prepend: Bool) {
        let months = (1...12).compactMap { month -> MonthModel? in
            let monthArray = calculateMonthArray(for: year, month: month)
            return MonthModel(monthArray: monthArray, monthName: MonthName(rawValue: month)?.name ?? "", monthYear: year)
        }
        
        if prepend {
            years.insert(year, at: 0)
        } else {
            years.append(year)
        }
        
        monthInYear[year] = months
    }
    
    func getCurrentYear() -> Int {
        guard let currentYear = years.firstIndex(of: currentYear) else { return 0 }
        return currentYear
    }

    func getCurrentMonth() -> IndexPath {
        guard let currentYear = years.firstIndex(of: currentYear) else { return IndexPath() }
       return IndexPath(row: currentMonth-1, section: currentYear)
    }

    // MARK: - Private Methods
    
    private func getInitialYears() {
        for offset in -1...1 {
            fetchYear(year: currentYear + offset, prepend: false)
        }
    }

    private func calculateMonthArray(for year: Int, month: Int) -> [[Int]] {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 4 * 60 * 60) ?? .current
        
        guard let firstDayOfMonth = calendar.date(from: DateComponents(year: year, month: month, day: 1)),
              let monthRange = calendar.range(of: .day, in: .month, for: firstDayOfMonth) else {
            return []
        }
        
        var weekday = calendar.component(.weekday, from: firstDayOfMonth)
        if DateFormatter().weekdaySymbols[weekday - 1] == "Sunday" {
            weekday = 8
        }
        
        var monthArray = [[Int]](repeating: [Int](repeating: 0, count: 7), count: 6)
        var day = 1

        for i in 0..<6 {
            for j in 0..<7 {
                if i == 0 && j < weekday - 2 {
                    continue
                }
                if day > monthRange.count {
                    break
                }
                monthArray[i][j] = day
                day += 1
            }
        }

        return monthArray
    }
}
