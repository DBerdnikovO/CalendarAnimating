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

class SecondViewController: UIViewController {
  
    
    var second: SecondView?  {
        didSet {
            self.view = second
            second?.selectedCell = selectedCell?.indexPath
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
      
    }

}
