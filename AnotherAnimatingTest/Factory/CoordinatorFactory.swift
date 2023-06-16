//
//  CoordinatorFactory.swift
//  AnotherAnimatingTest
//
//  Created by Данила Бердников on 16.06.2023.
//

import UIKit

class CoordinatorFactory {
    
    func createCoordinator(navigationController: UINavigationController) -> Coordinator {
        Coordinator(navigationController: navigationController)
    }
    
}
