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
}

class SecondViewController: UIViewController, SecondViewControllerProtocol {
    
    // MARK: - Properties
    
    var coordinator: Coordinator?
    var completion: ((IndexPath) -> ())?
    
    var calendarView: SecondView! {
        guard isViewLoaded else { return nil }
        return (view as? SecondView)
    }
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
    
    // MARK: - SecondViewDelegate Methods
    
    func getMiddleCell() -> SecondMonthCell? {
        guard let secondView = second,
              let middleCell = secondView.getMiddleCellOnDisplay() else { return nil }
        return middleCell
    }
    
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
