//
//  SecondMonthcell.swift
//  AnotherAnimatingTest
//
//  Created by Данила Бердников on 27.06.2023.
//

import UIKit
import SnapKit

protocol SecondDelegate:AnyObject {
    func getTappedData(data: TaskModel)
}

class SecondMonthCell: UICollectionViewCell, CellConfigureProtocol, UIGestureRecognizerDelegate {
    
    static var reuseIdentifier: String = "SecondMonthCell"
    
    weak var delegate: SecondDelegate?

    var indexPath: IndexPath?
    
    lazy var isTapped: Bool = false
    
    var year = 0
    
    private lazy var mainMonthView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var dayMonthView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.gray
        return view
    }()
    
    lazy var monthView: UIView = {
        let view = UIView()
//        view.backgroundColor = .blue
        return view
    }()
    
    private lazy var nameMonthViewLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.font = UIFont.systemFont(ofSize: 60)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.monthView.layer.sublayers = nil
        self.mainMonthView.layer.sublayers = nil
        //        self.monthDatesLayer = nil
        for subview in dayMonthView.subviews {
            subview.removeFromSuperview()
        }
    }
    
    
    deinit {
        print("I DEINIT")
    }
    
    func configure<U>(with value: U, indexPath: IndexPath) where U: Hashable {
        guard let month: MonthModel = value as? MonthModel else {return}
        year = month.monthYear
        self.indexPath = indexPath
        nameMonthViewLabel.text = month.monthName
        getMonthArray(monthArray: month.monthArray)

        setupViews()
        setupConstraints()
    }
    
    
    private func setupViews() {
        addSubview(mainMonthView)
        mainMonthView.addSubview(nameMonthViewLabel)
        mainMonthView.addSubview(monthView)

        mainMonthView.frame = self.bounds
    }
    
    private func setupConstraints() {
        nameMonthViewLabel.translatesAutoresizingMaskIntoConstraints = false
        monthView.translatesAutoresizingMaskIntoConstraints = false
        
        nameMonthViewLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
//            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(60)
        }
        
        monthView.snp.makeConstraints { make in
            make.top.equalTo(nameMonthViewLabel.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
    }
    
    func relocateLabel() {
        
        nameMonthViewLabel.snp.removeConstraints()
        
        UIView.animate(withDuration: 0.3) {
            self.nameMonthViewLabel.snp.updateConstraints { make in
                make.top.equalToSuperview()
                make.trailing.equalToSuperview()
                make.height.equalTo(20)
            }
            self.layoutIfNeeded()
            
        }
    }
    
    
    
    func getMonthArray(monthArray: [[Int]]) {
            let squareSize: CGFloat = (bounds.width / 7.35)
            let spacing: CGFloat = 3

            for i in 0..<6 {
                for j in 0..<7 {
                    let x = CGFloat(j) * (squareSize + spacing)
                    let y = CGFloat(i) * (squareSize + spacing)

                    let square = UILabel()
                    if String(monthArray[i][j]) != "0" {
                        square.text = String(monthArray[i][j])
                    }
                    
                    square.font = UIFont.systemFont(ofSize: squareSize / 2)
                    square.textAlignment = .center
                    square.textColor = UIColor.white
                    square.frame = CGRect(x: x, y: y, width: squareSize, height: squareSize)
                    square.layer.cornerRadius = square.frame.size.width / 2
                    square.clipsToBounds = true
                    monthView.addSubview(square)
                    
                    if square.text != nil {
                        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelTapped(_:)))
                                    square.isUserInteractionEnabled = true
                                    square.addGestureRecognizer(tapGesture)
                    }

                }
            }

        }
    
    
    @objc func labelTapped(_ gesture: UITapGestureRecognizer) {
        guard let label = gesture.view as? UILabel else {
            return
        }
        if (isTapped) {
            delegate?.getTappedData(data: TaskModel(monthName: nameMonthViewLabel.text!, monthYear: year))
            label.backgroundColor = nil
            isTapped = false
        } else {
            delegate?.getTappedData(data: TaskModel(monthName: nameMonthViewLabel.text!, monthYear: year))
            label.backgroundColor = .red
            isTapped = true
        }

    }
}
