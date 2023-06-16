//
//  ModuleFactory.swift
//  AnotherAnimatingTest
//
//  Created by Данила Бердников on 16.06.2023.
//

import Foundation

class ModuleFactory {
    
    func createFirstViewController() -> FirstViewController {
        FirstViewController()
    }
    
    func createSecondViewController() -> SecondViewController {
        SecondViewController()
    }
}
