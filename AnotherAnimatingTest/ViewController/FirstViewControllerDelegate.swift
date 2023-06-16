//
//  FirstViewController+Delegate.swift
//  AnotherAnimatingTest
//
//  Created by Данила Бердников on 14.06.2023.
//

import UIKit

extension FirstViewController: UIViewControllerTransitioningDelegate  {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCell = collectionView.cellForItem(at: indexPath) as? TextCell
        // 7
        selectedCellImageViewSnapshot = selectedCell?.imageView.snapshotView(afterScreenUpdates: false)

        print(selectedCellImageViewSnapshot)
        completionHandler?(CellData(image: (selectedCell?.imageView.image)!, selectedCellImageViewSnapshot: selectedCellImageViewSnapshot!))
    }

    // 3
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        // 17
//        guard let secondViewController = dismissed as? SecondViewController,
//            let selectedCellImageViewSnapshot = selectedCellImageViewSnapshot
//            else { return nil }
//
//        animator = Animator(type: .dismiss, firstViewController: self, secondViewController: secondViewController, selectedCellImageViewSnapshot: selectedCellImageViewSnapshot)
//        return animator
        return nil
    }
}
