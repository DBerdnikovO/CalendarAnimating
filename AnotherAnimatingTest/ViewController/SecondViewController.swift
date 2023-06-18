//
//  AotherViewController.swift
//  AnotherAnimatingTest
//
//  Created by Данила Бердников on 14.06.2023.
//

import UIKit

struct CellData {
    let image: UIImage
    let cellFrame: UIView

}

class SecondViewController: UIViewController {
    
    var data: CellData!
    
    var imageView = UIImageView()
    var locationLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue

        view.addSubview(imageView)
        imageView.addSubview(locationLabel)
        imageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height/2)
        configureCell()

        imageView.image = data.image
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    func configureCell() {
        
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
      
  
    }
}
