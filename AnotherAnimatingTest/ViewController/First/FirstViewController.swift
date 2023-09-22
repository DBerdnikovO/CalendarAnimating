//
//  ViewController.swift
//  AnotherAnimatingTest
//
//  Created by Данила Бердников on 14.06.2023.
//

import UIKit


class FirstViewController: UIViewController, FirstViewControllerProtocol  {
    
    // MARK: - Typealias
    typealias T = FirstMonthCell
    
    // MARK: - Properties
    weak var coordinator: Coordinator?
    var completionHandlerFirstViewController: ((T) -> ())?
    private let viewModel: CalendarViewModel = CalendarViewModel.shared()
    
    lazy var calendarView: FirstView = {
        let view = FirstView(frame: UIScreen.main.bounds)
        view.delegate = self
        view.month = viewModel.getMonths()
        return view
    }()
    
    // MARK: - Life Cycle
    override func loadView() {
        self.view = calendarView
        calendarView.collectionView.scrollToItem(at: IndexPath(item: 0, section: 1), at: .top, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - FirstViewDelegate
    func didSelectCell(cell: FirstMonthCell) {
//        cell.relocateLabel { [weak self] in
//            guard let self = self else { return }
            completionHandlerFirstViewController?(cell)
//        }
        
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





