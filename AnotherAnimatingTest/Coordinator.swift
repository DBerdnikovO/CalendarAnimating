//
//  MainViewController.swift
//  AnotherAnimatingTest
//
//  Created by Данила Бердников on 16.06.2023.
//

import UIKit

typealias CompletionHandler = ()->()

class Coordinator:NSObject, UINavigationControllerDelegate {
    
    var navigationController: UINavigationController
    let moduleFactory = ModuleFactory()
    
    var data: CellData?
        
    var flowCompletionHandler: CompletionHandler?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showFirstViewController()
        self.navigationController.delegate = self
        
    }
    
    func showFirstViewController() {
        let controller = moduleFactory.createFirstViewController()
        
        controller.completionHandler = { [weak self] value in
            guard let self = self else { return }
            self.showSecondViewController(with: value)
        }
        
        navigationController.pushViewController(controller, animated: false)
        
    }
    
    func showSecondViewController(with data: CellData) {
        print(data)
        let controller = moduleFactory.createSecondViewController()
        
        controller.transitioningDelegate = navigationController.viewControllers.first as? any UIViewControllerTransitioningDelegate
        
        self.data = data
        controller.data = data
        navigationController.pushViewController(controller, animated: true)
        
    }

}

extension Coordinator {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        guard let firstViewController = fromVC as? FirstViewController,
              let secondViewController = toVC as? SecondViewController,
              let selectedCellImageViewSnapshot = self.data?.selectedCellImageViewSnapshot
        else { return nil }
        
        let animator = Animator(type: .present, firstViewController: firstViewController, secondViewController: secondViewController, selectedCellImageViewSnapshot: selectedCellImageViewSnapshot)
         return animator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        print(" ID ")
            return nil
        }
}

