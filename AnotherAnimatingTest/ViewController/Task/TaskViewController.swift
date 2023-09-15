//
//  TaskViewController.swift
//  AnotherAnimatingTest
//
//  Created by Данила Бердников on 14.07.2023.
//

import UIKit

enum Importance {
    case high,medium,light
}

struct Task {
    let name: String
    let date: String
    let importance: Importance
}

class CustomCell: UICollectionViewCell {
    
    let gradientLayer = CAGradientLayer()
    
    var importance : Importance?
        
        override func layoutSubviews() {
            super.layoutSubviews()
        
            switch importance {
            case .high:
                gradientLayer.colors = [UIColor.white.cgColor, UIColor.red.cgColor]

            case .medium:
                gradientLayer.colors = [UIColor.white.cgColor, UIColor.yellow.cgColor]

            case .light:
                gradientLayer.colors = [UIColor.white.cgColor, UIColor.green.cgColor]

            case .none:
                print("ERREE")
            }
            // Set the colors for the gradient layer
            // Set the diagonal direction for the gradient layer
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 1, y: 1)
            
            // Set the frame of the gradient layer to match the cell's bounds
            gradientLayer.frame = bounds
            gradientLayer.cornerRadius = 10
            
            // Add the gradient layer as a sublayer of the cell's layer
            layer.insertSublayer(gradientLayer, at: 0)
            
        }
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .yellow
    }
    
    lazy var nameTask: UILabel = {
       let label = UILabel()
        return label
    }()
    
    lazy var dateTask: UILabel = {
        let label = UILabel()
         return label
     }()
    
    private lazy var mainMonthView: UIView = {
        let view = UIView()
        return view
    }()

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(task: Task) {
        nameTask.text = task.name
        dateTask.text = task.date
        importance = task.importance
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        addSubview(mainMonthView)
        mainMonthView.addSubview(nameTask)
        mainMonthView.addSubview(dateTask)
        mainMonthView.frame = self.bounds
//        mainMonthView.backgroundColor = .red
    }
    
    private func setupConstraints() {
        nameTask.translatesAutoresizingMaskIntoConstraints = false
        dateTask.translatesAutoresizingMaskIntoConstraints = false

        nameTask.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(20)
        }
         
        dateTask.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(20)
        }

    }
}

class TaskViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    var coordinator: Coordinator?

    let myView = UIView()
    
    var taskArray = [Task]()

    
    let customView = UIView()
    let cellIdentifier = "CustomCell"

   
        override func viewDidLoad() {
            super.viewDidLoad()
            myView.frame = view.frame
            myView.backgroundColor = .blue
            view.addSubview(myView)
//            configTasks()
            createCollectionView()
        }
        
//    func configTasks() {
//        taskArray.append(Task(name: "Пойти в спортзал", date: <#T##String#>, importance: <#T##Importance#>))
//    }
//    
    func createCollectionView() {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.itemSize = CGSize(width: view.frame.width - 50, height: 100)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CustomCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.backgroundColor = .white
        myView.addSubview(collectionView)

        // Set constraints for the collection view
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return 3
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
            if let cell = cell as? CustomCell {
                cell.configure(task: Task(name: "HELLo", date: "DATE", importance: Importance.light))
                return cell
            }
            cell.layer.cornerRadius = 10
            cell.clipsToBounds = true
            return cell
        }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
    }
    
    func getTappedData(data: TaskModel, isOpen: Bool) {
       
        if isOpen {


            UIView.animate(withDuration: 0.5) {
                self.customView.frame.origin.y = self.view.frame.height
                    } completion: { _ in
                        self.customView.removeFromSuperview()
                    }

        } else {
            let startFrame =  CGRect(x: 0, y:  self.view.frame.height, width:  self.view.frame.width, height:  self.view.frame.height/2)
            customView.frame = startFrame
            customView.backgroundColor = UIColor.red // Set your desired background color
            view.addSubview(customView)
            customView.layer.cornerRadius = 10
            customView.clipsToBounds = true

            UIView.animate(withDuration: 0.5) {
                self.customView.frame.origin.y =  self.view.frame.height/2
            }
        }

    }
}
