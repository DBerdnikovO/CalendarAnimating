//
//  AotherViewController.swift
//  AnotherAnimatingTest
//
//  Created by Данила Бердников on 14.06.2023.
//

import UIKit

struct CellData {
    let image: UIImage
    let cellFrame: UIView

}

protocol SecondViewDelegate: AnyObject {
    func getFirstValue()
    func getYearInSection()
    func getYearSection()
//    func goThirdController(task: TaskModel, isOpen: Bool)
}

class SecondViewController: UIViewController, SecondViewDelegate {
    
    // MARK: - Properties
    
    var coordinator: Coordinator?
    var completion: ((IndexPath) -> ())?
    weak var second: SecondView?  {
        didSet {
            self.view = second
            second?.selectedCell = selectedCell?.indexPath
            second?.delegate = self
        }
    }
    
    var selectedCell: FirstMonthCell?
    var viewModel: CalendarViewModel = CalendarViewModel.shared
    
    // MARK: - Lifecycle
    
    override func loadView() {
        let calendarView = SecondView(frame: UIScreen.main.bounds)
        calendarView.month = viewModel.getMonths()
        self.second = calendarView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        guard let secondView = second else { return }
        coordinator?.passDataBack(data: secondView.getMiddleCellOnDisplay()!)
    }
    
    // MARK: - SecondViewDelegate Methods
    
    func getFirstValue() {
        print("FIRST")
    }
    
    func getYearInSection() {
        print("YEAR")
    }
    
    func getYearSection() {
        print("Section")
    }
    
    // Uncomment if needed

//    func goThirdController(task: TaskModel, isOpen: Bool) {
//        coordinator?.showThirdViewController(task: task, isOpen: true)
//    }
    
}
