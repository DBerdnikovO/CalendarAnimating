//
//  HomeButton.swift
//  AnotherAnimatingTest
//
//  Created by Данила Бердников on 28.09.2023.
//

import UIKit

class HomeButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height / 2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupButton() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .red
        clipsToBounds = true
        setTitleColor(.white, for: .normal)
        setImage(UIImage(systemName: "house"), for: .normal)
        
        imageView?.contentMode = .scaleAspectFit
        contentHorizontalAlignment = .center
    }
    

}
