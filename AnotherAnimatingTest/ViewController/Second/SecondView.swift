//
//  SecondView.swift
//  AnotherAnimatingTest
//
//  Created by Данила Бердников on 21.06.2023.
//

import UIKit

class SecondView: UIView {
    
    // MARK: - Properties
    
    private static let sectionHeaderElementKind = "second-header-element-kind"
    
//    weak var delegate: SecondViewDelegate?
    var getMiddleSection: ((IndexPath) -> ())?
    
    var month: [Int: [MonthModel?]]! {
        didSet {
            years = month.keys.sorted()
            configureDataSource()
        }
    }
    
    private lazy var years: [Int] = []
    private lazy var isOpen = false
    
    var initialFrame: CGRect?
    private var initialCollectionViewFrame = CGRect()
    var selectedCell: IndexPath? {
        didSet {
            guard let cell = selectedCell else { return }
            collectionView.scrollToItem(at: cell, at: .top, animated: false)
        }
    }
    private var selectedCellImageViewSnapshot: UIView?
    
    private var snapshot = NSDiffableDataSourceSnapshot<Int, MonthModel?>()
    var dataSource: UICollectionViewDiffableDataSource<Int, MonthModel?>!
    var collectionView: UICollectionView!
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    
    // MARK: - Configuration
    
    private func configure() {
        backgroundColor = .black
        configureHierarchy()
    }
    
    private func configureHierarchy() {
        collectionView = UICollectionView(frame: bounds, collectionViewLayout: createLayout(type: .second))
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .black
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(collectionView)
    }
}

//MARK: Configure DataSource
extension SecondView {
    
    func getTappedData(data: TaskModel) {
        // Add your implementation here
    }
    
    private func configureDataSource() {
        // Cell configuration
        let cellRegistration = UICollectionView.CellRegistration<SecondMonthCell, MonthModel> { cell, indexPath, viewModel in
            cell.configure(with: viewModel, indexPath: indexPath)
        }
        
        // Header configuration
        let headerRegistration = UICollectionView.SupplementaryRegistration<YearsHeaderView>(
            elementKind: SecondView.sectionHeaderElementKind
        ) { [weak self] supplementaryView, _, indexPath in
            guard let self = self, let year = self.years[safe: indexPath.section] else { return }
            supplementaryView.yearsLabel.text = String(year)
            supplementaryView.configureAppearance()
        }
        
        // Data source configuration
        dataSource = UICollectionViewDiffableDataSource<Int, MonthModel?>(collectionView: collectionView) {
            collectionView, indexPath, itemIdentifier in
            
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        }
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
        }
        
        // Snapshot configuration
        for section in years {
            snapshot.appendSections([section])
            guard let items = month[section] else { return }
            snapshot.appendItems(items, toSection: Int(section))
        }
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func createLayout(type: ViewZoom) -> UICollectionViewLayout {
        // Define layout constants
        let itemInsets = NSDirectionalEdgeInsets(top: 3, leading: 3, bottom: 3, trailing: 3)
        let headerFooterHeightEstimation: CGFloat = 1302
        
        // Item and Group
        let itemSize = type.layouts.itemSize!
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = itemInsets
        
        let groupSize = type.layouts.groupSize!
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        // Section and Supplementary Items
        let section = NSCollectionLayoutSection(group: group)
        
        let headerFooterSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .estimated(headerFooterHeightEstimation))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerFooterSize,
                                                                        elementKind: SecondView.sectionHeaderElementKind, alignment: .top)
        section.boundarySupplementaryItems = [sectionHeader]
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    func getMiddleCellOnDisplay() -> SecondMonthCell? {
        let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        let middleCell = collectionView.indexPathForItem(at: visiblePoint) ?? IndexPath(row: 0, section: 0)
        guard let cell = collectionView.cellForItem(at: middleCell) as? SecondMonthCell else { return nil}
        return cell
    }
}

// MARK: Snapshot
extension SecondView {
    
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

// MARK: - Supplementary View Configuration

private extension UIView {
    func configureAppearance() {
        backgroundColor = .lightGray
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1.0
    }
}

private extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
 
