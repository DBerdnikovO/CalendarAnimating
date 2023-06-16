//
//  ViewController.swift
//  AnotherAnimatingTest
//
//  Created by Данила Бердников on 14.06.2023.
//

import UIKit

class FirstViewController: UIViewController, UICollectionViewDelegateFlowLayout, FlowController  {
    var completionHandler: ((CellData) -> ())?
    
    typealias T = CellData
    
    
    enum Section {
        case main
    }
    
    var selectedCell: TextCell?
    var selectedCellImageViewSnapshot: UIView?

    var dataSource: UICollectionViewDiffableDataSource<Section, Int>! = nil
    var collectionView: UICollectionView! = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureDataSource()
    }

}


extension FirstViewController {
    
    /// - Tag: Inset
    private func createLayout(type: ViewZoom) -> UICollectionViewLayout {
        
        
        let itemSize = type.layouts.itemSize!
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 1, bottom: 1, trailing: 1)
        
        let groupSize = type.layouts.groupSize!
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}
extension FirstViewController {
    
    func configureHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout(type: ViewZoom.first))
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        
        view.addSubview(collectionView)
    }
    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<TextCell, Int> { (cell, indexPath, identifier) in
            cell.configure()
           cell.mylabel.text = String(indexPath.row)
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, Int>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: Int) -> UICollectionViewCell? in
            // Return the cell.
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
        
        // initial data
        var snapshot = NSDiffableDataSourceSnapshot<Section, Int>()
        snapshot.appendSections([.main])
        snapshot.appendItems(Array(0..<394))
        dataSource.apply(snapshot, animatingDifferences: false)
    }
  
}


