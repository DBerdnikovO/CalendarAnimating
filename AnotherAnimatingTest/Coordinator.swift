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
        let navItem = UINavigationItem(title: "My Title")
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
        
        let controller = moduleFactory.createSecondViewController()
        
        controller.transitioningDelegate = navigationController.viewControllers.first as? any UIViewControllerTransitioningDelegate
        
        self.data = data
        controller.data = data
        navigationController.pushViewController(controller, animated: true)
        
    }
    
}

extension Coordinator {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if fromVC is FirstViewController
        {
            return moveController(type: .present, from: fromVC, to: toVC)
        }
        else {
            return moveController(type: .dismiss, from: toVC, to: fromVC)
        }
    }
    
}

extension Coordinator {
    
    func moveController(type: PresentationType, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning?{
        if let firstViewController = fromVC as? FirstViewController,
           let secondViewController = toVC as? SecondViewController,
           let selectedCellImageViewFrame = self.data?.cellFrame{
            let animator = Animator(type: type, firstViewController: firstViewController, secondViewController: secondViewController, selectedCellImageViewSnapshot: selectedCellImageViewFrame)
            return animator
            
        }
        else {
            
        }
        return nil
    }
}
