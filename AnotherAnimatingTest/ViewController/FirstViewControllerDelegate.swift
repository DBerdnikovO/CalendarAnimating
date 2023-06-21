//
//  FirstViewControllerDelegate.swift
//  AnotherAnimatingTest
//
//  Created by Данила Бердников on 18.06.2023.
//

import UIKit

extension FirstViewController {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        initialCollectionViewFrame = collectionView.frame
        
        selectedCell = collectionView.cellForItem(at: indexPath) as? TextCell
        // 7
        selectedCellImageViewSnapshot = selectedCell?.imageView.snapshotView(afterScreenUpdates: false)
        
        guard let selectedCell = selectedCell else { return }
        
        completionHandler?(selectedCell)
    }
    
}
