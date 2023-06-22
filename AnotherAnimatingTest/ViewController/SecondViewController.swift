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
    
    weak var second: SecondView?  {
        didSet {
            self.view = second
            second?.selectedCell = selectedCell
        }
    }
    
    weak var selectedCell: TextCell? 
    
 //   var image: UIImage!
    
    var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
 //   var locationLabel = UILabel()
//
    override func loadView() {
        let calendarView = SecondView(frame: UIScreen.main.bounds)
        self.second = calendarView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
       // self.imageView = selectedCell!.imageView
     //   configure
   //     view.addSubview(imageView)
//        imageView.addSubview(locationLabel)
//        imageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height/2)
  //     configureCell()
        //imageView.image = selectedCell?.imageView.image
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
