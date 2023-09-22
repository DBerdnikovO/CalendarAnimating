//
//  MainViewController.swift
//  AnotherAnimatingTest
//
//  Created by Данила Бердников on 16.06.2023.
//

import UIKit

class Coordinator:NSObject, UINavigationControllerDelegate {
    
    typealias CompletionHandler = () -> ()
    
    var navigationController: UINavigationController
    let moduleFactory = ModuleFactory()
    
    var selectedCell: CellConfigureProtocol?
    
    var flowCompletionHandler: CompletionHandler?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showFirstViewController()
        navigationController.delegate = self
    }
    
    private func showFirstViewController() {
        guard let controller = moduleFactory.createFirstViewController() else { return }
        controller.coordinator = self
        
        controller.completionHandlerFirstViewController = { [weak self] selectedCell in
            self?.selectedCell = selectedCell
            self?.showSecondViewController()
        }
        
        navigationController.pushViewController(controller, animated: false)
    }
    
    private func showSecondViewController() {
        let controller = moduleFactory.createSecondViewController()
        controller.coordinator = self
        controller.selectedCell = selectedCell as? FirstMonthCell
        navigationController.pushViewController(controller, animated: true)
    }
    
    //    func showThirdViewController(task: TaskModel, isOpen: Bool) {
    //         guard let controller = moduleFactory.createThirdViewController() else { return }
    //         controller.coordinator = self
    //         controller.getTappedData(data: task, isOpen: isOpen)
    //         controller.modalPresentationStyle = .formSheet
    //         navigationController.present(controller, animated: true)
    //     }
    
    //    func passDataBack(data: SecondMonthCell) {
    //        if navigationController.viewControllers.first is FirstViewController {
    //            data.backLanbel()
    //            self.didPressedCell = data
    //        }
    //    }
}


// MARK: - UINavigationControllerDelegate

extension Coordinator {
    
    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationController.Operation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch fromVC {
        case is FirstViewController:
            return createAnimator(type: .present, from: fromVC, to: toVC)
        case is SecondViewController:
            return handleSecondViewControllerTransition(from: fromVC, to: toVC)
        default:
            return nil
        }
    }
    
    private func handleSecondViewControllerTransition(from fromVC: UIViewController, 
                                                      to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let from = fromVC as? SecondViewController,
              let to = toVC as? FirstViewController,
              let middleCell = from.getMiddleCell(),
              let indexPath = middleCell.indexPath,
              let cell = to.calendarView.collectionView.cellForItem(at: indexPath) as? CellConfigureProtocol else {
            return nil
        }
        selectedCell = cell
        return createAnimator(type: .dismiss, from: fromVC, to: toVC)
    }
    
    
    private func createAnimator(type: PresentationType,
                                from fromVC: UIViewController,
                                to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let cell = selectedCell as? FirstMonthCell else { return nil }
        
        if let from = fromVC as? FirstViewController, let to = toVC as? SecondViewController {
            return NewAnimator(type: type, fromViewController: from, toViewController: to, cell: cell)
        } else if let from = fromVC as? SecondViewController, let to = toVC as? FirstViewController {
            return NewAnimator(type: type, fromViewController: to, toViewController: from, cell: cell)
        }
        return nil
    }
    
}
