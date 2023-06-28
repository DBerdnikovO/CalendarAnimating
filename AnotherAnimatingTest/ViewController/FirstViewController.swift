//
//  ViewController.swift
//  AnotherAnimatingTest
//
//  Created by Данила Бердников on 14.06.2023.
//

import UIKit

class FirstViewController: UIViewController, FlowController, FirstViewDelegate  {
    
    var completionHandler: ((FirstMonthCell) -> ())?
    
    typealias T = FirstMonthCell
    
    private let viewModel: CalendarViewModel = CalendarViewModel.shared()
    
    var calendarView: FirstView! {
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
        
}





