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
    
    weak var second: SecondView?  {
        didSet {
            self.view = second
            second?.selectedCell = selectedCell
        }
    }
    
    weak var selectedCell: TextCell? 
    

    override func loadView() {
        let calendarView = SecondView(frame: UIScreen.main.bounds)
        self.second = calendarView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
  }

}
