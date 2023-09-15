//
//  SecondView.swift
//  AnotherAnimatingTest
//
//  Created by Данила Бердников on 21.06.2023.
//

import UIKit

class SecondView: UIView, SecondDelegate{
    
    lazy var isOpen = false
    let customView = UIView()

    func getTappedData(data: TaskModel) {
    
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

    }
    
    
    static let sectionHeaderElementKind = "second-header-element-kind"
    
    weak var delegate: SecondViewDelegate?
        
    var getMiddleSection: ((IndexPath)->())?
    
    var month: [Int:[MonthModel?]]!  {
        didSet {
            years = month.keys.sorted()
            configureDataSource()
        }
    }
    
    lazy var years: [Int] = [Int]()
    
    var initialFrame: CGRect?
    
    var initialCollectionViewFrame = CGRect()
    
    var selectedCell: IndexPath? {
        didSet {
            collectionView.scrollToItem(at: selectedCell!, at: .top, animated: false)
        }
    }
    var selectedCellImageViewSnapshot: UIView?
    
    private var snapshot = NSDiffableDataSourceSnapshot<Int, MonthModel?>()
    var dataSource: UICollectionViewDiffableDataSource<Int, MonthModel?>! = nil
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


extension SecondView {
    
    func configureHierarchy() {
        collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: createLayout(type: ViewZoom.second))
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .black
//        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(collectionView)
    }
    
    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<SecondMonthCell, MonthModel> { cell, indexPath, viewModel in
            cell.delegate = self
            cell.configure(with: viewModel, indexPath: indexPath)
        }
        
        let headerRegistration = UICollectionView.SupplementaryRegistration<YearsHeaderView>(
            elementKind: SecondView.sectionHeaderElementKind
        ) { [weak self] supplementaryView, _, indexPath in
            guard let self = self else { return }
            
            let newSection = years
            
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
        item.contentInsets = NSDirectionalEdgeInsets(top: 3, leading: 3, bottom: 3, trailing: 3)
        
        let groupSize = type.layouts.groupSize!
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        let headerFooterSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .estimated(1302))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerFooterSize,
            elementKind: SecondView.sectionHeaderElementKind, alignment: .top)
        
        section.boundarySupplementaryItems = [sectionHeader]
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    func getMiddleCellOnDisplay() -> IndexPath? {
        let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        
        if let indexPath = collectionView.indexPathForItem(at: visiblePoint) {
            return (indexPath)
        }
        
        return nil
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
}

