//
//  MainViewController.swift
//  AnotherAnimatingTest
//
//  Created by Данила Бердников on 16.06.2023.
//

import UIKit

class Coordinator:NSObject, UINavigationControllerDelegate {
    
    // MARK: Typealias
    typealias CompletionHandler = ()->()
    
    var navigationController: UINavigationController
    let moduleFactory = ModuleFactory()
    
    var didPressedCell: FirstMonthCell?
    
    var animator: Animator?
    
    var flowCompletionHandler: CompletionHandler?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Navigation Flow
    
    func start() {
        showFirstViewController()
        self.navigationController.delegate = self
    }
    
    private func showFirstViewController() {
        guard let controller = moduleFactory.createFirstViewController() else { return }
        controller.coordinator = self
        
        controller.completionHandlerFirstViewController = { [weak self] data in
            self?.showSecondViewController(with: data)
        }
        
        navigationController.pushViewController(controller, animated: false)
    }
    
    private func showSecondViewController(with data: FirstMonthCell) {
         let controller = moduleFactory.createSecondViewController()
         controller.coordinator = self
         controller.transitioningDelegate = navigationController.viewControllers.first as? UIViewControllerTransitioningDelegate
         self.didPressedCell = data
         navigationController.pushViewController(controller, animated: true)
         controller.selectedCell = data
     }
     
//    func showThirdViewController(task: TaskModel, isOpen: Bool) {
//         guard let controller = moduleFactory.createThirdViewController() else { return }
//         controller.coordinator = self
//         controller.getTappedData(data: task, isOpen: isOpen)
//         controller.modalPresentationStyle = .formSheet
//         navigationController.present(controller, animated: true)
//     }
    
    func passDataBack(data: IndexPath) {
            if let firstViewController = navigationController.viewControllers.first as? FirstViewController {
                let data = firstViewController.calendarView.collectionView.cellForItem(at: data) as! FirstMonthCell
                self.didPressedCell = data
            }
        }
}


// MARK: - UINavigationControllerDelegate

extension Coordinator {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if fromVC is FirstViewController {
            return moveController(type: .present, from: fromVC, to: toVC)
        } else {
            return moveController(type: .dismiss, from: fromVC, to: toVC)
        }
    }
    
    private func moveController(type: PresentationType, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if let firstViewController = fromVC as? FirstViewController,
           let secondViewController = toVC as? SecondViewController,
           let data = self.didPressedCell {
            return NewAnimator(type: type, fromViewController: firstViewController, toViewController: secondViewController, cell: data)
        } else if let firstViewController = fromVC as? SecondViewController,
                  let secondViewController = toVC as? FirstViewController,
                  let cell = didPressedCell {
            return NewAnimator(type: type, fromViewController: secondViewController, toViewController: firstViewController, cell: cell)
        }
        return nil
    }
}
