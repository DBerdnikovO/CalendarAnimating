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
    private var fromViewController: FirstViewController
    private var toViewController: SecondViewController
    private let cell: TextCell?
    
    init?(type: PresentationType, fromViewController: FirstViewController, toViewController: SecondViewController, cell: TextCell?) {
        self.type = type
        self.fromViewController = fromViewController
        
        self.toViewController = toViewController
        
        self.fromViewController.calendarView.collectionView.transform = CGAffineTransform.identity
        self.fromViewController.calendarView.collectionView.collectionViewLayout.invalidateLayout()
        // 11
        self.cell = cell
    }
    
    // 12
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return Self.duration
    }
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        if type.isPresenting {
            
            let containerView = transitionContext.containerView
            
            containerView.addSubview(toViewController.view)
            toViewController.view.alpha = 0.0
            
            let height = self.fromViewController.topbarHeight
            let visibleRect = CGRect(origin: fromViewController.calendarView.collectionView.contentOffset, size: fromViewController.calendarView.collectionView.bounds.size)
            
            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                self.fromViewController.calendarView.collectionView.transform = CGAffineTransform(scaleX: 3, y: 3)
                self.fromViewController.calendarView.collectionView.frame.origin.y = -self.cell!.frame.minY * 3 + visibleRect.origin.y * 3 + height
                self.fromViewController.calendarView.collectionView.frame.origin.x =  -self.cell!.frame.minX * 3
            }, completion: { finished in
                self.toViewController.view.alpha = 1.0
                self.toViewController.view.transform = CGAffineTransform.identity
                transitionContext.completeTransition(finished)
            })
        } else {
            let containerView = transitionContext.containerView
            
            guard let toView = fromViewController.view
            else {
                transitionContext.completeTransition(false)
                return
            }
            
            containerView.addSubview(toView)
            
            guard
                let controllerImageSnapshot = cell?.imageView.snapshotView(afterScreenUpdates: true)
            else {
                transitionContext.completeTransition(true)
                return
            }
            
            [ controllerImageSnapshot].forEach { containerView.addSubview($0) }
            
            fromViewController.calendarView.collectionView.frame = fromViewController.calendarView.initialCollectionViewFrame
            [ controllerImageSnapshot].forEach {
                $0.layer.cornerRadius = 0
                $0.layer.masksToBounds = true
            }
            controllerImageSnapshot.alpha = 0
            let height = self.fromViewController.topbarHeight
            let visibleRect = CGRect(origin: fromViewController.calendarView.collectionView.contentOffset, size: fromViewController.calendarView.collectionView.bounds.size)
            
            
            self.fromViewController.calendarView.collectionView.transform = CGAffineTransform(scaleX: 3, y: 3)
            self.fromViewController.calendarView.collectionView.frame.origin.y = -self.cell!.frame.minY * 3 + visibleRect.origin.y * 3 + height
            self.fromViewController.calendarView.collectionView.frame.origin.x =  -self.cell!.frame.minX * 3
            
            UIView.animateKeyframes(withDuration: Self.duration, delay: 0, options: .calculationModeCubic, animations: {
                
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1) {
                    self.fromViewController.calendarView.collectionView.transform = CGAffineTransform(scaleX: 1, y: 1)
                    self.fromViewController.calendarView.collectionView.frame = self.fromViewController.calendarView.initialCollectionViewFrame
                }
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.6) {
                    controllerImageSnapshot.alpha = 0
                    toView.alpha = 1
                }
                
            }, completion: { _ in
                controllerImageSnapshot.removeFromSuperview()
                transitionContext.completeTransition(true)
            })
        }
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

