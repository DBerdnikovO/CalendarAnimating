//
//  ViewController.swift
//  AnotherAnimatingTest
//
//  Created by Данила Бердников on 14.06.2023.
//

import UIKit

class FirstViewController: UIViewController, FlowController, FirstViewDelegate  {

    var coordinator: Coordinator?
    
    var completionHandler: ((FirstMonthCell) -> ())?

    
    typealias T = FirstMonthCell
    
    private let viewModel: CalendarViewModel = CalendarViewModel.shared()
    
    weak var calendarView: FirstView! {
        guard isViewLoaded else { return nil }
        return (view as? FirstView)
    }

    override func loadView() {
        let calendarView = FirstView(frame: UIScreen.main.bounds)
        calendarView.delegate = self
        calendarView.month = viewModel.getMonths()
        self.view = calendarView
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func didSelectCell(cell: FirstMonthCell) {
        completionHandler?(cell)
    }
    
    func getFirstValue()-> Int {
        return 0
    }
    
    func getYearInSection(year: Int, isUp: Bool) {
        print("AS")
    }
    
    func getYearSection(complition: ([Int : [MonthViewModel?]]) -> Void) {
        print("ASd")
    }
    
    
    func getLastValue() -> Int {
        return 0
    }
        
}





