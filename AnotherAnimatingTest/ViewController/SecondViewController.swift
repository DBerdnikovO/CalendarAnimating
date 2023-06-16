//
//  AotherViewController.swift
//  AnotherAnimatingTest
//
//  Created by Данила Бердников on 14.06.2023.
//

import UIKit

struct CellData {
    let title: String
}

class SecondViewController: UIViewController {
    
    var data: CellData!
    
    var locationImageView = UIView()
    var closeButton = UIButton()
    var locationLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
//        configureCell()
        view.addSubview(locationImageView)
        closeButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
       // view.addSubview(button)
        locationImageView.addSubview(locationLabel)
        locationImageView.addSubview(closeButton)
        configureCell()

        locationImageView.backgroundColor = .brown
        closeButton.backgroundColor = .blue
        locationLabel.text = data.title
        locationLabel.backgroundColor = .white
       // print(cellNumber)
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    func configureCell() {
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.frame.size = CGSize(width: 20, height: 20)
        
        locationLabel.frame.size = CGSize(width: 100, height: 100)
        locationImageView.frame = CGRect(x: 0, y: view.frame.minY, width: view.frame.width, height: 400)
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            locationLabel.centerXAnchor.constraint(equalTo: locationImageView.centerXAnchor),
            locationLabel.centerYAnchor.constraint(equalTo: locationImageView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: locationImageView.topAnchor,constant: 50),
            closeButton.leadingAnchor.constraint(equalTo: locationImageView.leadingAnchor,constant: 30)
        ])
    }
}
