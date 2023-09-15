//
//  NewAnimator.swift
//  AnotherAnimatingTest
//
//  Created by Данила Бердников on 23.06.2023.

import UIKit

final class NewAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    // MARK: - Constants
    private static let duration: TimeInterval = 1.25
    private let contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 1, bottom: 1, trailing: 1)
    private let transformScale: CGFloat = 3.0
    private let backgroundAlpha: CGFloat = 0.97
    
    // MARK: - Private Properties
    private var cellSnapshot = UIView()
    private let type: PresentationType
    private let fromViewController: FirstViewController
    private let toViewController: SecondViewController
    private let cell: FirstMonthCell
    
    // MARK: - Initializer
    init?(type: PresentationType, fromViewController: FirstViewController, toViewController: SecondViewController, cell: FirstMonthCell) {
        self.type = type
        self.fromViewController = fromViewController
        self.toViewController = toViewController
        self.cell = cell
        
        self.fromViewController.calendarView.collectionView.transform = CGAffineTransform.identity
        self.fromViewController.calendarView.collectionView.collectionViewLayout.invalidateLayout()
    }
    
    // MARK: - Transitioning Protocol Methods
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return NewAnimator.duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView
        let toView = type.isPresenting ? toViewController.view : fromViewController.view
        let targetViewController = type.isPresenting ? toViewController : fromViewController
        let transform = CGAffineTransform(scaleX: 3, y: 3)
        let height = type.isPresenting ? fromViewController.topbarHeight : toViewController.topbarHeight
        let visibleRect = CGRect(origin: fromViewController.calendarView.collectionView.contentOffset, size: fromViewController.calendarView.collectionView.bounds.size)
        let backgroundVIwe = UIView(frame: containerView.frame)
        let cellFrameInContainerView = fromViewController.calendarView.collectionView.convert(cell.frame, to: containerView)
        
        backgroundVIwe.backgroundColor = .black
        backgroundVIwe.alpha = 0
        
        guard let targetView = toView,
              let cellImageSnapshot = cell.snapshotView(afterScreenUpdates: true)
        else {
            transitionContext.completeTransition(false)
            return
        }
        
        cellSnapshot = cellImageSnapshot
        
        cellSnapshot.frame = cellFrameInContainerView.offsetBy(dx: 0, dy: self.contentInsets.bottom)
        
        
        [backgroundVIwe, cellSnapshot, targetView].forEach{ containerView.addSubview($0)}
        targetView.alpha = type.isPresenting ? 0.0 : 1.0
        
        if !type.isPresenting {
            adjustCollectionViewPosition(transform: transform, visibleRect: visibleRect, height: height)
        }
        
        let animations: () -> Void = { [weak self] in
            guard let self = self else { return }
            if targetViewController is SecondViewController {
                adjustCollectionViewPosition(transform: transform, visibleRect: visibleRect, height: height)
                backgroundVIwe.alpha = 0.97
                
            } else {
                self.fromViewController.calendarView.collectionView.transform = CGAffineTransform(scaleX: 1, y: 1)
                self.fromViewController.calendarView.collectionView.frame = self.fromViewController.calendarView.initialCollectionViewFrame
            }
        }
        
        let completion: (Bool) -> Void = { [weak self] finished in
            guard let self = self else { return }
            if self.type.isPresenting {
                UIView.animate(withDuration: 1) {
                    self.toViewController.view.alpha = 1.0
                    
                }
                containerView.alpha = 1
            }
            transitionContext.completeTransition(finished)
        }
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: animations, completion: completion)
    }
    
    func adjustCollectionViewPosition(transform: CGAffineTransform, visibleRect: CGRect, height: CGFloat) {
        
        fromViewController.calendarView.collectionView.transform = transform
        fromViewController.calendarView.collectionView.frame.origin.y = -cell.frame.minY * 3 + visibleRect.origin.y * 3 + height
        fromViewController.calendarView.collectionView.frame.origin.x =  -cell.frame.minX * 3 + contentInsets.bottom * 3
        
        cellSnapshot.frame = CGRect(x: contentInsets.bottom * 3, y:height + contentInsets.bottom , width: cell.frame.width*3, height: cell.frame.height*3)
        
    }
}
