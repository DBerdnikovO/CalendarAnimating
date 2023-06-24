//
//  NewAnimator.swift
//  AnotherAnimatingTest
//
//  Created by Данила Бердников on 23.06.2023.

import UIKit

final class NewAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    static let duration: TimeInterval = 1.25
    private let contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 1, bottom: 1, trailing: 1)
    
    private let type: PresentationType
    private var fromViewController: FirstViewController
    private var toViewController: SecondViewController
    private let cell: TextCell?
    
    init?(type: PresentationType, fromViewController: FirstViewController, toViewController: SecondViewController, cell: TextCell?) {
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
        let transform = self.type.isPresenting ? CGAffineTransform(scaleX: 3, y: 3) : CGAffineTransform.identity
        let height = fromViewController.topbarHeight
        let visibleRect = CGRect(origin: fromViewController.calendarView.collectionView.contentOffset, size: fromViewController.calendarView.collectionView.bounds.size)
        
        guard let cell = cell, let targetView = toView else {
            transitionContext.completeTransition(false)
            return
        }
        
        if !type.isPresenting {
            print(height, visibleRect)
            adjustCollectionViewPosition(visibleRect: visibleRect, height: height)
        }
        
        containerView.addSubview(targetView)
        targetView.alpha = type.isPresenting ? 0.0 : 1.0
        
        let animations: () -> Void = { [weak self] in
            guard let self = self else { return }
            if targetViewController is SecondViewController {
                self.fromViewController.calendarView.collectionView.transform = transform
                self.fromViewController.calendarView.collectionView.frame.origin.y = -cell.frame.minY * 3 + visibleRect.origin.y * 3 + height
                self.fromViewController.calendarView.collectionView.frame.origin.x = -cell.frame.minX * 3 + self.contentInsets.bottom * 3
            } else {
                self.fromViewController.calendarView.collectionView.transform = CGAffineTransform(scaleX: 1, y: 1)
                self.fromViewController.calendarView.collectionView.frame = self.fromViewController.calendarView.initialCollectionViewFrame
            }
        }
        
        
        let completion: (Bool) -> Void = { [weak self]  finished in
            guard let self = self else { return }
            if self.type.isPresenting {
                self.toViewController.view.alpha = 1.0
                self.toViewController.view.transform = CGAffineTransform.identity
            } else {
                cell.imageView.snapshotView(afterScreenUpdates: true)?.removeFromSuperview()
            }
            transitionContext.completeTransition(finished)
        }
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: animations, completion: completion)
    }
    
    func adjustCollectionViewPosition(visibleRect: CGRect, height: CGFloat) {
        guard let cell = cell else { return }
        fromViewController.calendarView.collectionView.transform = CGAffineTransform(scaleX: 3, y: 3)
        fromViewController.calendarView.collectionView.frame.origin.y = -cell.frame.minY * 3 + visibleRect.origin.y * 3 + height * 2
        fromViewController.calendarView.collectionView.frame.origin.x =  -cell.frame.minX * 3 + self.contentInsets.bottom * 3
        
    }
}
