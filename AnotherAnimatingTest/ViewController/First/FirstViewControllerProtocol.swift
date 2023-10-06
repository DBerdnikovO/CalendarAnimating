//
//  FirstViewProtocol.swift
//  AnotherAnimatingTest
//
//  Created by Данила Бердников on 21.09.2023.
//

import UIKit


protocol FirstViewControllerProtocol: UIViewController, AnimatingProtocol {
    
    func didSelectCell(cell: FirstMonthCell)
    
}
