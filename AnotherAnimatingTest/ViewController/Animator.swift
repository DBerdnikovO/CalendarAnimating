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
    private var selectedCellImageViewSnapshot: UIView
    private let cellImageViewRect: CGRect
    private let cell: TextCell?
    //   private let selectedCell: TextCell?
    
    // 45
    //private let cellLabelRect: CGRect
    //
    //    // 10
    init?(type: PresentationType, fromViewController: FirstViewController, toViewController: SecondViewController, selectedCellImageViewSnapshot: UIView, cell: TextCell?) {
        self.type = type
        self.fromViewController = fromViewController
        
        self.toViewController = toViewController
        self.selectedCellImageViewSnapshot = selectedCellImageViewSnapshot
        
    //    self.fromViewController.calendarView.collectionView.transform = CGAffineTransform.identity
        self.fromViewController.calendarView.collectionView.collectionViewLayout.invalidateLayout()

        guard let window = fromViewController.view.window ?? toViewController.view.window,
              let selectedCell = fromViewController.calendarView.selectedCell
        else { return nil }
        
        // 11
        self.cellImageViewRect = selectedCell.imageView.convert(selectedCell.imageView.bounds, to: window)
        self.cell = cell
    }
    
    // 12
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return Self.duration
    }
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        if type.isPresenting {
            
            let containerView = transitionContext.containerView
            
            // Add the toVC's view to the container
            containerView.addSubview(toViewController.view)
            
            // Set the initial state for the animation
            toViewController.view.alpha = 0.0
         //   toViewController.view.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            let height = self.fromViewController.topbarHeight
            let visibleRect = CGRect(origin: fromViewController.calendarView.collectionView.contentOffset, size: fromViewController.calendarView.collectionView.bounds.size)
            
            
            // Perform the animation
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
            self.fromViewController.calendarView.collectionView.transform = CGAffineTransform.identity
         //   self.fromViewController.collectionView.collectionViewLayout.invalidateLayout()
            let containerView = transitionContext.containerView

            // 19
            guard let toView = fromViewController.view
                else {
                    transitionContext.completeTransition(false)
                    return
            }

            containerView.addSubview(toView)

            // 21
            guard
                let selectedCell = fromViewController.calendarView.selectedCell,
                let window = fromViewController.view.window ?? toViewController.view.window,
                let controllerImageSnapshot = toViewController.imageView.snapshotView(afterScreenUpdates: true)
    //            let cellLabelSnapshot = selectedCell.locationLabel.snapshotView(afterScreenUpdates: true), // 47
               // let closeButtonSnapshot = toViewController.closeButton.snapshotView(afterScreenUpdates: true) // 53
                else {
                    transitionContext.completeTransition(true)
                    return
            }

            // 40
            let backgroundView: UIView
          
            backgroundView = fromViewController.view.snapshotView(afterScreenUpdates: true)!
             
            // 23
            toView.alpha = 0

            [backgroundView, selectedCellImageViewSnapshot, controllerImageSnapshot].forEach { containerView.addSubview($0) }

            fromViewController.calendarView.collectionView.frame = fromViewController.calendarView.initialCollectionViewFrame
            // 25
            let controllerImageViewRect = toViewController.imageView.convert(toViewController.imageView.bounds, to: window)

            [selectedCellImageViewSnapshot, controllerImageSnapshot].forEach {
                $0.frame = controllerImageViewRect

                // 59
                $0.layer.cornerRadius = 0
                $0.layer.masksToBounds = true
            }

            // 36
            controllerImageSnapshot.alpha = 1
            let height = self.fromViewController.topbarHeight
            let visibleRect = CGRect(origin: fromViewController.calendarView.collectionView.contentOffset, size: fromViewController.calendarView.collectionView.bounds.size)
            print(visibleRect)
            let pointInCollectionView = cell!.convert(cell!.contentView.frame.origin, to: fromViewController.calendarView.collectionView)
            
            print(self.cell!.frame)
            // 37
            selectedCellImageViewSnapshot.alpha = 0

            UIView.animateKeyframes(withDuration: Self.duration, delay: 0, options: .calculationModeCubic, animations: {

                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1) {
                    // 38

                  
                    controllerImageSnapshot.frame = self.cell!.frame
//                    controllerImageSnapshot.frame.origin = pointInCollectionView
//                  //  controllerImageSnapshot.frame.origin.x += height
//
//                 //   controllerImageSnapshot.frame = self.cell!.frame


                    [controllerImageSnapshot, self.selectedCellImageViewSnapshot].forEach {
                        $0.layer.cornerRadius = 12
                    }
                }

                // 39
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.6) {
                    self.selectedCellImageViewSnapshot.alpha = 0
                    controllerImageSnapshot.alpha = 1
                    toView.alpha = 1

                }


            }, completion: { _ in
                // 29
                self.selectedCellImageViewSnapshot.removeFromSuperview()
                controllerImageSnapshot.removeFromSuperview()

                backgroundView.removeFromSuperview()

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

