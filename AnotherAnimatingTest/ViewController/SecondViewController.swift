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
    
    
    
    var image: UIImage!
    
    var imageView = UIImageView()
    var locationLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        view.addSubview(imageView)
        imageView.addSubview(locationLabel)
        imageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height/2)
        configureCell()
        print(self.navigationController?.navigationBar.frame.height)
        imageView.image = image
    }
 
    
    func configureCell() {
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 44),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
      
  
    }
}
