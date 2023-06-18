//
//  Animator.swift
//  CustomTransitionTutorial
//
//  Created by Tung on 27.11.19.
//  Copyright © 2019 Tung. All rights reserved.
//

import UIKit

// 8
final class Animator: NSObject, UIViewControllerAnimatedTransitioning {
    
    //
    static let duration: TimeInterval = 1.25
    
    private let type: PresentationType
    private let fromViewController: FirstViewController
    private let toViewController: SecondViewController
    private var selectedCellImageViewSnapshot: UIView
    private let cellImageViewRect: CGRect
    
    // 45
    private let cellLabelRect: CGRect
    //
    //    // 10
    init?(type: PresentationType, firstViewController: FirstViewController, secondViewController: SecondViewController, selectedCellImageViewSnapshot: UIView) {
        self.type = type
        
        self.fromViewController = firstViewController
        self.toViewController = secondViewController
        self.selectedCellImageViewSnapshot = selectedCellImageViewSnapshot
        
        guard let window = firstViewController.view.window ?? secondViewController.view.window,
              let selectedCell = firstViewController.selectedCell
        else { return nil }
        
        // 11
        self.cellImageViewRect = selectedCell.imageView.convert(selectedCell.imageView.bounds, to: window)
        
        // 46
        self.cellLabelRect = selectedCell.imageView.convert(selectedCell.imageView.bounds, to: window)
    }
    
    // 12
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return Self.duration
    }
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let isPresenting = type.isPresenting
        print(isPresenting)
        
        let containerView = transitionContext.containerView
       
//
//            guard let fromVC = fromViewController as? FirstViewController,
//                  let toVC = transitionContext.viewController(forKey: .to)
//            else {
//                transitionContext.completeTransition(false)
//                return
//            }
//
//

        
        // Add the toVC's view to the container
        containerView.addSubview(toViewController.view)
        
        // Set the initial state for the animation
        toViewController.view.alpha = 0.0
        toViewController.view.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        
        let height = fromViewController.topbarHeight
        let visibleRect = CGRect(origin: fromViewController.collectionView.contentOffset, size: fromViewController.collectionView.bounds.size)
        
        // Perform the animation
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            
            if isPresenting {
                self.fromViewController.view.transform = CGAffineTransform(scaleX: 3, y: 3)
                self.fromViewController.view.frame.origin.y = -self.fromViewController.selectedCell!.frame.minY * 3 + visibleRect.origin.y * 3 + height
                self.fromViewController.view.frame.origin.x = -self.fromViewController.selectedCell!.frame.minX * 3
            }
            else {
                
            }

        }, completion: { finished in
            self.toViewController.view.alpha = 1.0
            self.toViewController.view.transform = CGAffineTransform.identity
            transitionContext.completeTransition(finished)
        })
    }
    
}

// 14
enum PresentationType {
    
    case present
    case dismiss
    
    var isPresenting: Bool {
        return self == .present
    }
}

