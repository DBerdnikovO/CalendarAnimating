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
    
    var data: TextCell?
    
    var animator: Animator?
    
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
        
        controller.completionHandler = { [weak self] data in
            guard let self = self else { return }
            self.showSecondViewController(with: data)
        }
        
        navigationController.pushViewController(controller, animated: false)
        
    }
    
    func showSecondViewController(with data: TextCell) {

        let controller = moduleFactory.createSecondViewController()
        
        controller.transitioningDelegate = navigationController.viewControllers.first as? any UIViewControllerTransitioningDelegate
        
        self.data = data
        controller.image = data.imageView.image
        navigationController.pushViewController(controller, animated: true)
        
    }
    
}

extension Coordinator {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
       
        if fromVC is FirstViewController
        {
            return  moveController(type: .present, from: fromVC, to: toVC)
        }
        else {
            return moveController(type: .dismiss, from: fromVC, to: toVC)
        }
    }
    
}

extension Coordinator {
    
    func moveController(type: PresentationType, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning?{
        if let firstViewController = fromVC as? FirstViewController,
           let secondViewController = toVC as? SecondViewController,
           let selectedCellImageViewFrame = self.data?.imageView,
           let data = self.data{
           animator = Animator(type: type, fromViewController: firstViewController, toViewController: secondViewController, selectedCellImageViewSnapshot: selectedCellImageViewFrame, cell: data)
            return animator
            
        }
        else if let firstViewController = fromVC as? SecondViewController,
                let secondViewController = toVC as? FirstViewController,
                let selectedCellImageViewFrame = self.data?.imageView,
                let data = self.data {
            let animator = Animator(type: type, fromViewController: secondViewController, toViewController: firstViewController, selectedCellImageViewSnapshot: selectedCellImageViewFrame, cell: data)
             return animator
        }
        return nil
    }
}
