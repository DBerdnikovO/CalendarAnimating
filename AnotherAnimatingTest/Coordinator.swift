//
//  MainViewController.swift
//  AnotherAnimatingTest
//
//  Created by Данила Бердников on 16.06.2023.
//

import UIKit

class Coordinator {
    
    var navigationController: UINavigationController
    let moduleFactory = ModuleFactory()

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showFirstViewCOntroller()
    }
    
    func showFirstViewCOntroller() {
        let controller = moduleFactory.createFirstViewController()
        
        navigationController.pushViewController(controller, animated: false)
    }
}

