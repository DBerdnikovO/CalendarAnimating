//
//  YearsHeaderView.swift
//  AnotherAnimatingTest
//
//  Created by Данила Бердников on 27.06.2023.
//

import UIKit

class YearsHeaderView: UICollectionReusableView {
    let yearsLabel = UILabel()

    static var reuseIdentifier: String {
      return String(describing: YearsHeaderView.self)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
}

extension YearsHeaderView {
    func configure() {
        addSubview(yearsLabel)
        yearsLabel.translatesAutoresizingMaskIntoConstraints = false
        yearsLabel.adjustsFontForContentSizeCategory = true
        let inset = CGFloat(15)
        NSLayoutConstraint.activate([
            yearsLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset),
            yearsLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -inset),
            yearsLabel.topAnchor.constraint(equalTo: topAnchor, constant: inset),
            yearsLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -inset)
        ])
        yearsLabel.font = UIFont.preferredFont(forTextStyle: .title3)
    }
}

