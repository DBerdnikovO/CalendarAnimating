//
//  textCell.swift
//  AnotherAnimatingTest
//
//  Created by Данила Бердников on 14.06.2023.
//

import UIKit

protocol ExpandedCellDelegate:NSObjectProtocol{
    func touched(indexPath:IndexPath)
}

class TextCell: UICollectionViewCell {
    
    lazy var mylabel:UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .green
        return label
    }()
    let myVIew =  UIView()
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var indexPath: IndexPath?
    
    weak var delegate:ExpandedCellDelegate?

    static let reuseIdentifier = "text-cell-reuse-identifier"

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        labelConfigure()
    }
    required init?(coder: NSCoder) {
        fatalError("not implemnted")
    }
    deinit {
        print("I DEINIT")
    }

   
}

extension TextCell {
    func configure() {
        
        imageView.image = UIImage(named: "images/2")
        imageView.contentMode = .scaleAspectFill
        self.backgroundColor = .yellow
        
    }

    func setupView() {
        contentView.addSubview(imageView)
        contentView.addSubview(mylabel)
    }
    
    func labelConfigure() {
        NSLayoutConstraint.activate([
            mylabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            mylabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: contentView.heightAnchor),
        ])
    }
    
    
}

