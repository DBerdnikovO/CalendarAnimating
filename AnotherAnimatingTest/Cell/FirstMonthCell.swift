//
//  YearMonthCell.swift
//  AnotherAnimatingTest
//
//  Created by Данила Бердников on 26.06.2023.
//

import UIKit
import SnapKit

protocol CellConfigureProtocol {
    static var reuseIdentifier: String {get}
    func configure<U: Hashable>(with value: U,indexPath: IndexPath)
}


class FirstMonthCell: UICollectionViewCell, CellConfigureProtocol {

    static var reuseIdentifier: String = "FirstMonthCell"
    
    var indexPath: IndexPath?

    private lazy var mainMonthView: UIView = {
        let view = UIView()
        return view
    }()

    private lazy var monthDatesLayer: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = UIColor.black.cgColor
        return layer
    }()

    lazy var monthView: UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        return view
    }()

    private lazy var nameMonthViewLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
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
        self.monthDatesLayer.sublayers?.removeAll()
    }
    

    deinit {
        print("I DEINIT")
    }

    func configure<U>(with value: U, indexPath: IndexPath) where U: Hashable {
        guard let month: MonthViewModel = value as? MonthViewModel else {return}
        
        self.indexPath = indexPath
        nameMonthViewLabel.text = month.monthName
        setupViews()
        setupConstraints()
        getMonthArray(monthArray: month.monthArray)
    }


    private func setupViews() {
        addSubview(mainMonthView)
        mainMonthView.addSubview(nameMonthViewLabel)
        mainMonthView.addSubview(monthView)
        mainMonthView.frame = self.bounds
        mainMonthView.backgroundColor = .red
    }

    private func setupConstraints() {
        nameMonthViewLabel.translatesAutoresizingMaskIntoConstraints = false
        monthView.translatesAutoresizingMaskIntoConstraints = false

        nameMonthViewLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(20)
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
        let squareSize: CGFloat = bounds.width / 7.35
        let spacing: CGFloat = 1

        for i in 0..<6 {
            for j in 0..<7 {

                let x = CGFloat(j) * (squareSize + spacing)
                let y = CGFloat(i) * (squareSize + spacing)

                let square = CATextLayer()
                if String(monthArray[i][j]) != "0" {
                    square.string = String(monthArray[i][j])
                }
                square.fontSize = squareSize / 2
                square.alignmentMode = .center
                square.foregroundColor = UIColor.black.cgColor
                square.contentsScale = UIScreen.main.scale
                square.frame = CGRect(x: x, y: y, width: squareSize, height: squareSize)

                self.monthDatesLayer.addSublayer(square)
            }
        }

        self.monthView.layer.addSublayer(self.monthDatesLayer)
    }
}
