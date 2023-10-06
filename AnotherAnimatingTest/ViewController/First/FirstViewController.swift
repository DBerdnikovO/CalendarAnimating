//
//  ViewController.swift
//  AnotherAnimatingTest
//
//  Created by Данила Бердников on 14.06.2023.
//

import UIKit


class FirstViewController: UIViewController, FirstViewControllerProtocol  {
    
    // MARK: - Typealias
    typealias T = FirstMonthCell
    
    // MARK: - Properties
    weak var coordinator: Coordinator?
    let currentYear = Calendar.current.component(.year, from: Date())
    var completionHandlerFirstViewController: ((T) -> ())?
    private let viewModel: CalendarViewModel = CalendarViewModel.shared()
    
    lazy var calendarView: FirstView = {
        let view = FirstView(frame: UIScreen.main.bounds)
        view.collectionView.delegate = self
        
        view.month = viewModel.getMonths()
        return view
    }()
    
    // MARK: - Life Cycle
    override func loadView() {
        self.view = calendarView
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        calendarView.collectionView.scrollToItem(at: IndexPath(item: 11, section: viewModel.getCurrentYear()-1), at: .top, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupObserver()
    }
    
    
    // MARK: - FirstViewDelegate
    func didSelectCell(cell: FirstMonthCell) {
        completionHandlerFirstViewController?(cell)
    }
    
    func setupObserver() {
            NotificationCenter.default.addObserver(self, selector: #selector(receiveData(_:)), name: .pressedCell, object: nil)
        }
    @objc func receiveData(_ notification: Notification) {
        if notification.object is Bool {
                calendarView.collectionView.scrollToItem(at: IndexPath(item: 11, section: viewModel.getCurrentYear()-1), at: .top, animated: true)
            }
        }
    
}

extension FirstViewController {
    //MARK: ViewModelFunc
    func yearInSection(year: Int, ascendingOrder isUp: Bool) {
        viewModel.fetchYear(year: year, prepend: isUp)
    }
    
    func firstValue()-> Int {
        viewModel.getFirstYearValue()
    }
    
    func lastValue() -> Int {
        viewModel.getLastYearValue()
    }
    
    func monthInSection(section: Int) -> [MonthModel?] {
        viewModel.getMonthInSection(year: section)
    }
}


//MARK: UICollectionViewDelegate
extension FirstViewController: UICollectionViewDelegate {
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        calendarView.initialCollectionViewFrame = collectionView.frame
        
        let selectedCell = collectionView.cellForItem(at: indexPath) as? FirstMonthCell
        guard let selectedCell = selectedCell else { return }
        self.calendarView.collectionView.frame = collectionView.frame
        
        selectedCell.relocateLabel { [weak self] in
            guard let self = self else { return }
            self.didSelectCell(cell: selectedCell)
        }
    }
    //
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
    private func appendNewSections(atTop: Bool = false) {
        
        if atTop {
            let firstSection = self.firstValue()
            let newFirstSection = firstSection - 1
            yearInSection(year: newFirstSection, ascendingOrder: true)
            calendarView.applySnapshot(newSection: newFirstSection, newItems: viewModel.getMonthInSection(year: newFirstSection), isUp: true)
        }
        else {
            let lastSection = lastValue()
            let newLastSection = lastSection + 1
            yearInSection(year: newLastSection, ascendingOrder: false)
            calendarView.applySnapshot(newSection: newLastSection, newItems: viewModel.getMonthInSection(year: newLastSection), isUp: false)
        }
    }
}




