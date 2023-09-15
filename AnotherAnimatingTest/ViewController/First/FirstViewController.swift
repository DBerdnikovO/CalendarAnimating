//
//  ViewController.swift
//  AnotherAnimatingTest
//
//  Created by Данила Бердников on 14.06.2023.
//

import UIKit

class FirstViewController: UIViewController, FlowController, FirstViewDelegate  {
    
    // MARK: - Typealias
    typealias T = FirstMonthCell
    
    // MARK: - Properties
    var coordinator: Coordinator?
    var completionHandlerFirstViewController: ((T) -> ())?
    private let viewModel: CalendarViewModel = CalendarViewModel.shared
    
    var calendarView: FirstView! {
        guard isViewLoaded else { return nil }
        return (view as? FirstView)
    }
    
    // MARK: - Life Cycle
    override func loadView() {
        let calendarView = FirstView(frame: UIScreen.main.bounds)
        calendarView.delegate = self
        calendarView.month = viewModel.getMonths()
        self.view = calendarView
        calendarView.collectionView.scrollToItem(at: IndexPath(item: 11, section: 0), at: .top, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - FirstViewDelegate
    func didSelectCell(cell: FirstMonthCell) {
        completionHandlerFirstViewController?(cell)
    }
    
    func firstValue()-> Int {
        return 0
    }
    
    func yearInSection(year: Int, ascendingOrder isUp: Bool) {
        print("AS")
    }
    
    func yearSection(completion complition: ([Int : [MonthModel?]]) -> Void) {
        print("ASd")
    }
    
    func lastValue() -> Int {
        return 0
    } 
    
}





