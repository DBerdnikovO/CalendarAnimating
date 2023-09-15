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

class SecondViewController: UIViewController, SecondViewDelegate {
    
  
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
    var viewModel: CalendarViewModel = CalendarViewModel.shared()
    
    

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
        coordinator?.passDataBack(data: secondView.getMidlleCellOnDisplay())
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
}
