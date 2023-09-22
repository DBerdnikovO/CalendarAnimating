//
//  SecondView.swift
//  AnotherAnimatingTest
//
//  Created by Данила Бердников on 21.06.2023.
//

import UIKit

class SecondView: UIView, SecondDelegate {
    
    // MARK: - Properties
    
    private static let sectionHeaderElementKind = "second-header-element-kind"
    
    weak var delegate: SecondViewDelegate?
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
        backgroundColor = .blue
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

// MARK: - Extensions

extension SecondView {
    
    func getTappedData(data: TaskModel) {
        // Add your implementation here
    }
    
    private func configureDataSource() {
        // Cell configuration
        let cellRegistration = UICollectionView.CellRegistration<SecondMonthCell, MonthModel> { cell, indexPath, viewModel in
            cell.delegate = self
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
    
//    
//    private func appendNewSections(atTop: Bool = false) {
//
//        if atTop {
//            DispatchQueue.main.async(execute: {
//
//                CATransaction.begin()
//                CATransaction.setDisableActions(true)
//
//                let contentHeight = self.collectionView.contentSize.height
//                let offsetY = self.collectionView.contentOffset.y
//                let firstSection = self.calendarViewModelController.getFirstValue()
//
//                let bottomOffset = contentHeight - offsetY
//                let newFirstSection = firstSection - 1
//
//
//                self.calendarViewModelController.getYearInSection(year: newFirstSection, isUp: true)
//                self.calendarViewModelController.getYearSection {[weak self] sections in
//                    guard let newItems = sections[newFirstSection] else { return }
//                    guard let strogSelf = self else { return }
//                    strogSelf.snapshot.insertSections([newFirstSection], beforeSection: firstSection)
//                    strogSelf.snapshot.appendItems(newItems,toSection: newFirstSection)
//                }
//
//                self.collectionView.performBatchUpdates ({
//                    self.applySnapshot()
//                }, completion: { finished in
//                    self.collectionView.layoutIfNeeded()
//                    self.collectionView.contentOffset = CGPoint(x: 0, y: self.collectionView.contentSize.height - bottomOffset)
//                    CATransaction.commit()
//                })
//            })
//        }
//        else {
//            let lastSection = calendarViewModelController.getLastValue()
//            let newLastSection = lastSection + 1
//            calendarViewModelController.getYearInSection(year: newLastSection, isUp: false)
//            calendarViewModelController.getYearSection {[weak self] sections in
//                guard let strongSelf = self else { return }
//                guard let newItems = sections[newLastSection] else { return }
//                strongSelf.snapshot.appendSections([newLastSection])
//                strongSelf.snapshot.appendItems(newItems)
//                strongSelf.applySnapshot()
//            }
//        }
//    }
//    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let offsetY = scrollView.contentOffset.y
//        let contentHeight = scrollView.contentSize.height
//        let height = scrollView.frame.size.height
//        if offsetY > contentHeight - height {
//            appendNewSections()
//        } else if offsetY < 0{
//            appendNewSections(atTop: true)
//        }
//    }
    
    //        let layout = UICollectionViewFlowLayout()
    //        layout.itemSize = CGSize(width: 50, height: 50)
    //        layout.minimumInteritemSpacing = 10
    //        layout.minimumLineSpacing = 10
    //
    //        customView.addSubview(UICollectionView(frame: customView.frame))
    //        if isOpen {
    //            isOpen = false
    //
    //            delegate?.goThirdController(task: data, isOpen: isOpen)
    //
    //        } else {
    //            isOpen = true
    //
    //            delegate?.goThirdController(task: data, isOpen: isOpen)
    //        }
    //        if isOpen {
    //
    //
    //            UIView.animate(withDuration: 0.5) {
    //                self.customView.frame.origin.y = self.frame.height
    //                    } completion: { _ in
    //                        self.customView.removeFromSuperview()
    //                        self.isOpen = false
    //                    }
    //
    //        } else {
    //            let startFrame =  CGRect(x: 0, y: frame.height, width: frame.width, height: frame.height/2)
    //            customView.frame = startFrame
    //            customView.backgroundColor = UIColor.red // Set your desired background color
    //            addSubview(customView)
    //            customView.layer.cornerRadius = 10
    //            customView.clipsToBounds = true
    //
    //            UIView.animate(withDuration: 0.5) {
    //                self.customView.frame.origin.y = self.frame.height/2
    //            }
    //            isOpen = true
    //        }


