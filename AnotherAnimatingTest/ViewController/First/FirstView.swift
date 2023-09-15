//
//  FirstView.swift
//  AnotherAnimatingTest
//
//  Created by Данила Бердников on 21.06.2023.
//

import UIKit

class FirstView: UIView, UICollectionViewDelegate{
    
    static let sectionHeaderElementKind = "first-header-element-kind"
    
    weak var delegate: FirstViewDelegate?
    
    
    var month: [Int:[MonthViewModel?]]!  {
        didSet {
            years = month.keys.sorted()
            configureDataSource()
        }
    }
    
    lazy var years: [Int] = [Int]()
    
    var initialFrame: CGRect?
    
    var initialCollectionViewFrame = CGRect()
    
    var selectedCell: FirstMonthCell?
    var selectedCellImageViewSnapshot: UIView?
    
    private var snapshot = NSDiffableDataSourceSnapshot<Int, MonthViewModel?>()
    var dataSource: UICollectionViewDiffableDataSource<Int, MonthViewModel?>! = nil
    var collectionView: UICollectionView! = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    private func configure() {
        backgroundColor = .blue
        configureHierarchy()
    }
}


extension FirstView {
    
    func configureHierarchy() {
        collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: createLayout(type: ViewZoom.first))
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .black
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(collectionView)
    }
    
    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<FirstMonthCell, MonthViewModel> { cell, indexPath, viewModel in
            cell.configure(with: viewModel, indexPath: indexPath)
        }
        
        let headerRegistration = UICollectionView.SupplementaryRegistration<YearsHeaderView>(
            elementKind: FirstView.sectionHeaderElementKind
        ) { [weak self] supplementaryView, _, indexPath in
            guard let self = self else { return }
            
            let newSection = years
            
            supplementaryView.yearsLabel.text = String(newSection[indexPath.section])
            
            supplementaryView.backgroundColor = .lightGray
            supplementaryView.layer.borderColor = UIColor.black.cgColor
            supplementaryView.layer.borderWidth = 1.0
        }
        
        dataSource = UICollectionViewDiffableDataSource<Int, MonthViewModel?>(collectionView: collectionView) {
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
            snapshot.appendSections([section])
            guard let items = month[section] else { return }
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

extension FirstView {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        initialCollectionViewFrame = collectionView.frame
        
        selectedCell = collectionView.cellForItem(at: indexPath) as? FirstMonthCell
        // 7
        selectedCellImageViewSnapshot = selectedCell?.monthView.snapshotView(afterScreenUpdates: false)
        
        guard let selectedCell = selectedCell else { return }
        self.collectionView.frame = initialCollectionViewFrame
        
        delegate?.didSelectCell(cell: selectedCell)
        
    }

}

extension FirstView {
    private func appendNewSections(atTop: Bool = false) {

        if atTop {
//            DispatchQueue.main.async(execute: {
//
//                CATransaction.begin()
//                CATransaction.setDisableActions(true)
//
//                let contentHeight = self.collectionView.contentSize.height
//                let offsetY = self.collectionView.contentOffset.y
//                let firstSection = self.delegate?.getFirstValue()
//
//                let bottomOffset = contentHeight - offsetY
//                let newFirstSection = firstSection! - 1
//
//                self.delegate?.getYearInSection(year: newFirstSection, isUp: true)
////                self.calendarViewModelController.getYearInSection(year: newFirstSection, isUp: true)
//                self.delegate?.getYearSection(complition: { [weak self] sections in
//                    guard let newItems = sections[newFirstSection] else { return }
//                    guard let strogSelf = self else { return }
//                    strogSelf.snapshot.insertSections([newFirstSection], beforeSection: firstSection!)
//                    strogSelf.snapshot.appendItems(newItems,toSection: newFirstSection)
//                })
////                self.calendarViewModelController.getYearSection {[weak self] sections in
////                    guard let newItems = sections[newFirstSection] else { return }
////                    guard let strogSelf = self else { return }
////                    strogSelf.snapshot.insertSections([newFirstSection], beforeSection: firstSection)
////                    strogSelf.snapshot.appendItems(newItems,toSection: newFirstSection)
////                }
//
//                self.collectionView.performBatchUpdates ({
//                    self.applySnapshot()
//                }, completion: { finished in
//                    self.collectionView.layoutIfNeeded()
//                    self.collectionView.contentOffset = CGPoint(x: 0, y: self.collectionView.contentSize.height - bottomOffset)
//                    CATransaction.commit()
//                })
//            })
        }
        else {
            let lastSection = delegate?.getLastValue()
            let newLastSection = lastSection! + 1
            delegate?.getYearInSection(year: newLastSection, isUp: false)
            delegate?.getYearSection(complition: { [weak self] sections in
                guard let strongSelf = self else { return }
                guard let newItems = sections[newLastSection] else { return }
                strongSelf.snapshot.appendSections([newLastSection])
                strongSelf.snapshot.appendItems(newItems)
                strongSelf.applySnapshot()
            })
//            calendarViewModelController.getYearInSection(year: newLastSection, isUp: false)
//            calendarViewModelController.getYearSection {[weak self] sections in
//                guard let strongSelf = self else { return }
//                guard let newItems = sections[newLastSection] else { return }
//                strongSelf.snapshot.appendSections([newLastSection])
//                strongSelf.snapshot.appendItems(newItems)
//                strongSelf.applySnapshot()
//            }
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        if offsetY > contentHeight - height {
            appendNewSections()
        } else if offsetY < 0{
            appendNewSections(atTop: true)
        }
    }
    
    private func applySnapshot() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.dataSource.apply(self.snapshot, animatingDifferences: false)
        }
    }
}
