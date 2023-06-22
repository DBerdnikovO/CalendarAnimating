//
//  ViewController.swift
//  AnotherAnimatingTest
//
//  Created by Данила Бердников on 14.06.2023.
//

import UIKit

class FirstViewController: UIViewController, FlowController, FirstViewDelegate  {
    
    var completionHandler: ((TextCell) -> ())?
    
    typealias T = TextCell
    
    var calendarView: FirstView! {
        guard isViewLoaded else { return nil }
        return (view as? FirstView)
    }
    
    
    override func loadView() {
        let calendarView = FirstView(frame: UIScreen.main.bounds)
        calendarView.delegate = self
        self.view = calendarView
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func didSelectCell(cell: TextCell) {
        completionHandler?(cell)
    }
        
}





