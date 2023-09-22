//
//  FirstView.swift
//  AnotherAnimatingTest
//
//  Created by Данила Бердников on 21.06.2023.
//

import UIKit

protocol CalendarViewProtocol {
    func updateCalendar()
}

class FirstView: UIView, UICollectionViewDelegate {
    
    // MARK: - Constants
    static let sectionHeaderElementKind = "first-header-element-kind"
    
    // MARK: - Properties
    weak var delegate: FirstViewDelegate?
    var month: [Int:[MonthModel?]]?  {
        didSet {
            guard let month = month?.keys.sorted() else { return }
            years = month
            configureDataSource()
        }
    }
    lazy var years: [Int] = [Int]()
    private var initialFrame: CGRect?
    var initialCollectionViewFrame = CGRect()
    var selectedCell: FirstMonthCell?
    var selectedCellImageViewSnapshot: UIView?
    private var snapshot = NSDiffableDataSourceSnapshot<Int, MonthModel?>()
    var dataSource: UICollectionViewDiffableDataSource<Int, MonthModel?>! = nil
    var collectionView: UICollectionView! = nil
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Configuration
    private func configure() {
        backgroundColor = .blue
        configureHierarchy()
    }
    
    func configureHierarchy() {
        collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: createLayout(type: ViewZoom.first))
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .black
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(collectionView)
    }
}

// MARK: - Data Source Configuration
extension FirstView {
    
    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<FirstMonthCell, MonthModel> { [weak self] cell, indexPath, viewModel in
            guard let self = self else { return }
            cell.configure(with: viewModel, indexPath: indexPath)
        }
        
        let headerRegistration = UICollectionView.SupplementaryRegistration<YearsHeaderView>(
            elementKind: FirstView.sectionHeaderElementKind
        ) { [weak self] supplementaryView, _, indexPath in
            guard let self = self else { return }
            
            let newSection = years
            print(years.count)
            
            supplementaryView.yearsLabel.text = String(newSection[indexPath.section])
            
            supplementaryView.backgroundColor = .lightGray
            supplementaryView.layer.borderColor = UIColor.black.cgColor
            supplementaryView.layer.borderWidth = 1.0
        }
        
        dataSource = UICollectionViewDiffableDataSource<Int, MonthModel?>(collectionView: collectionView) {
            collectionView, indexPath, itemIdentifire in
            
            collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration,
                for: indexPath,
                item: itemIdentifire
            )
        }
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            return collectionView.dequeueConfiguredReusableSupplementary(
                using: headerRegistration,
                for: indexPath
            )
        }
        
        for section in years {
            guard let items = month?[section] else { return }
            snapshot.appendSections([section])
            snapshot.appendItems(items, toSection: Int(section))
        }
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func update() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.dataSource.apply(self.snapshot, animatingDifferences: false)
        }
    }
    
    
}

// MARK: - Layout
extension FirstView {
    private func createLayout(type: ViewZoom) -> UICollectionViewLayout {
        
        
        let itemSize = type.layouts.itemSize!
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 1, bottom: 1, trailing: 1)
        
        let groupSize = type.layouts.groupSize!
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        let headerFooterSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .estimated(44))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerFooterSize,
            elementKind: FirstView.sectionHeaderElementKind, alignment: .top)
        
        section.boundarySupplementaryItems = [sectionHeader]
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}


// MARK: Snapshot
extension FirstView {
    
    func applySnapshot(newSection: Int,newItems: [MonthModel?], isUp: Bool) {
        
        if !snapshot.sectionIdentifiers.contains(newSection) {
            if isUp {
                DispatchQueue.main.async(execute: { [weak self] in
                    guard let self = self else { return }
                    CATransaction.begin()
                    CATransaction.setDisableActions(true)
                    
                    let contentHeight = self.collectionView.contentSize.height
                    let offsetY = self.collectionView.contentOffset.y
                    
                    let bottomOffset = contentHeight - offsetY
                    
                    self.snapshot.insertSections([newSection], beforeSection: newSection + 1)
                    self.snapshot.appendItems(newItems,toSection: newSection)
                    
                    self.years.append(newSection)
                    self.years.sort()
                    
                    self.collectionView.performBatchUpdates ({
                        self.dataSource.apply(self.snapshot, animatingDifferences: false)
                    }, completion: { finished in
                        self.collectionView.layoutIfNeeded()
                        self.collectionView.contentOffset = CGPoint(x: 0, y: self.collectionView.contentSize.height - bottomOffset)
                        CATransaction.commit()
                    })
                    
                })
                
            } else {
                snapshot.appendSections([newSection])
                snapshot.appendItems(newItems,toSection: newSection)
                years.append(newSection)
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.dataSource.apply(self.snapshot, animatingDifferences: false)
                }
            }
            
        }
        
    }
    
    
}

