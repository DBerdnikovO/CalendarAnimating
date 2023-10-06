//
//  AotherViewController.swift
//  AnotherAnimatingTest
//
//  Created by Данила Бердников on 14.06.2023.
//

import UIKit

class SecondViewController: UIViewController, AnimatingProtocol {
    
    // MARK: - Properties
    
    var coordinator: Coordinator?
    var completion: ((IndexPath) -> ())?
    
    weak var calendarView: SecondView?  {
        didSet {
            self.view = calendarView
            calendarView?.collectionView.delegate = self
            calendarView?.selectedCell = selectedCell?.indexPath
        }
    }
    
    var selectedCell: FirstMonthCell?
    var viewModel: CalendarViewModel = CalendarViewModel.shared()
    
    // MARK: - Lifecycle
    
    override func loadView() {
        let calendarView = SecondView(frame: UIScreen.main.bounds)
        calendarView.month = viewModel.getMonths()
        navigationControllerSetup()
        self.calendarView = calendarView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func navigationControllerSetup() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "house"), style: .done, target: self, action: #selector(homeButtonTapped))
    }
    
    @objc private func homeButtonTapped() {
        let currentMonth = viewModel.getCurrentMonth()
        calendarView?.collectionView.scrollToItem(at: currentMonth, at: .top, animated: true)
    }
    // MARK: - SecondViewDelegate Methods
    
    func getMiddleCell() -> SecondMonthCell? {
        guard let secondView = calendarView,
              let middleCell = secondView.getMiddleCellOnDisplay() else { return nil }
        return middleCell
    }
    
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

    
    // Uncomment if needed

//    func goThirdController(task: TaskModel, isOpen: Bool) {
//        coordinator?.showThirdViewController(task: task, isOpen: true)
//    }
    
}

//MARK: CollectionViewDelegate
extension SecondViewController: UICollectionViewDelegate {
    
    func setupObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(receiveData(_:)), name: .pressedDay, object: nil)
        }
    
    @objc func receiveData(_ notification: Notification) {
        guard let indexPath = notification.object as? IndexPath else { return }
        print(indexPath)
        calendarView?.collectionView.scrollToItem(at: indexPath, at: .top, animated: true)
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
            let firstSection = self.firstValue() - 1
            yearInSection(year: firstSection, ascendingOrder: true)
            calendarView?.applySnapshot(newSection: firstSection, newItems: monthInSection(section: firstSection), isUp: true)
        }
        else {
            let lastSection = lastValue()
            let newLastSection = lastSection + 1
            yearInSection(year: newLastSection, ascendingOrder: false)
            calendarView?.applySnapshot(newSection: newLastSection, newItems: monthInSection(section: newLastSection), isUp: false)
        }
    }
}
