////
////  FirstViewController+Delegate.swift
////  AnotherAnimatingTest
////
////  Created by Данила Бердников on 14.06.2023.
////
//
//import UIKit
//
//extension FirstViewController: UIViewControllerTransitioningDelegate  {
//    
//    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
////        // 16
//        
//        
//        guard let firstViewController = presenting as? FirstViewController else {
//                // Handle the case when the presenting view controller is not a FirstViewController
//                return nil
//            }
//
////        guard let firstViewController = presenting as? FirstViewController,
////            let secondViewController = presented as? SecondViewController,
////            let selectedCellImageViewSnapshot = selectedCellImageViewSnapshot
////            else { return nil }
////        print("DAD")
////
////        animator = Animator(type: .present, firstViewController: firstViewController, secondViewController: secondViewController, selectedCellImageViewSnapshot: selectedCellImageViewSnapshot)
////        return animator
//        return nil
//    }
//
//    // 3
//    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        // 17
////        guard let secondViewController = dismissed as? SecondViewController,
////            let selectedCellImageViewSnapshot = selectedCellImageViewSnapshot
////            else { return nil }
////
////        animator = Animator(type: .dismiss, firstViewController: self, secondViewController: secondViewController, selectedCellImageViewSnapshot: selectedCellImageViewSnapshot)
////        return animator
//        return nil
//    }
//}
