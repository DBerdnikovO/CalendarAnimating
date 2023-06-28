//
//  NewAnimator.swift
//  AnotherAnimatingTest
//
//  Created by Данила Бердников on 23.06.2023.

import UIKit

enum SectionColelctionViewCell {
    
    case left
    case center
    case right
    
}

extension CGRect {
    
    init?(view: UIView, section: SectionColelctionViewCell) {
        switch section {
        case .left:
            self.init(x: -view.frame.width, y: view.frame.height, width: view.frame.width, height: view.frame.height)
        case .center:
            self.init(x: view.frame.midX - view.frame.width/2, y: view.frame.height, width: view.frame.width, height: view.frame.height)
        case .right:
            self.init(x: view.frame.width, y: view.frame.height, width: view.frame.width, height: view.frame.height)
        }
    }
    
}

final class NewAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    static let duration: TimeInterval = 1.25
    private let contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 1, bottom: 1, trailing: 1)
    
    private let type: PresentationType
    private var fromViewController: FirstViewController
    private var toViewController: SecondViewController
    private let cell: FirstMonthCell?
    
    init?(type: PresentationType, fromViewController: FirstViewController, toViewController: SecondViewController, cell: FirstMonthCell?) {
        self.type = type
        self.fromViewController = fromViewController
        self.toViewController = toViewController
        self.cell = cell
        
        self.fromViewController.calendarView.collectionView.transform = CGAffineTransform.identity
        self.fromViewController.calendarView.collectionView.collectionViewLayout.invalidateLayout()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return Self.duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView
        let toView = type.isPresenting ? toViewController.view : fromViewController.view
        let targetViewController = type.isPresenting ? toViewController : fromViewController
        let transform = CGAffineTransform(scaleX: 3, y: 3)
        let height = type.isPresenting ? fromViewController.topbarHeight : toViewController.topbarHeight
        let visibleRect = CGRect(origin: fromViewController.calendarView.collectionView.contentOffset, size: fromViewController.calendarView.collectionView.bounds.size)
   
        guard let cell = cell, let targetView = toView else {
            transitionContext.completeTransition(false)
            return
        }
        
        containerView.addSubview(targetView)
        targetView.alpha = type.isPresenting ? 0.0 : 1.0
        
        if !type.isPresenting {
           adjustCollectionViewPosition(transform: transform, visibleRect: visibleRect, height: height)
        }
        
        let animations: () -> Void = { [weak self] in
            guard let self = self else { return }
            if targetViewController is SecondViewController {
                adjustCollectionViewPosition(transform: transform, visibleRect: visibleRect, height: height)

            } else {
                self.fromViewController.calendarView.collectionView.transform = CGAffineTransform(scaleX: 1, y: 1)
                self.fromViewController.calendarView.collectionView.frame = self.fromViewController.calendarView.initialCollectionViewFrame
            }
        }
        
        
        let completion: (Bool) -> Void = { [weak self] finished in
            guard let self = self else { return }
            if self.type.isPresenting {
                self.toViewController.view.alpha = 1.0
            } else {
                cell.monthView.snapshotView(afterScreenUpdates: true)?.removeFromSuperview()
            }
            transitionContext.completeTransition(finished)
        }
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: animations, completion: completion)
    }
    
    func adjustCollectionViewPosition(transform: CGAffineTransform, visibleRect: CGRect, height: CGFloat) {
        guard let cell = cell else { return }
        fromViewController.calendarView.collectionView.transform = transform
        fromViewController.calendarView.collectionView.frame.origin.y = -cell.frame.minY * 3 + visibleRect.origin.y * 3 + height
        fromViewController.calendarView.collectionView.frame.origin.x =  -cell.frame.minX * 3 + self.contentInsets.bottom * 3

    }
}
