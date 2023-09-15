import UIKit
import SnapKit

protocol CellConfigureProtocol {
    static var reuseIdentifier: String { get }
    func configure<U: Hashable>(with value: U, indexPath: IndexPath)
}

class FirstMonthCell: UICollectionViewCell, CellConfigureProtocol {
    
    // MARK: - Static Properties
    static let reuseIdentifier: String = "FirstMonthCell"
    
    // MARK: - Instance Properties
    var indexPath: IndexPath?

    private lazy var mainMonthView: UIView = UIView()

    private lazy var monthDatesLayer: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = UIColor.black.cgColor
        return layer
    }()
    
    private lazy var monthView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
     lazy var nameMonthViewLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        label.textColor = .red
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle Methods
    override func prepareForReuse() {
        super.prepareForReuse()
        monthView.layer.sublayers = nil
        mainMonthView.layer.sublayers = nil
        monthDatesLayer.sublayers?.removeAll()
    }
    
    deinit {
        print("I DEINIT")
    }

    // MARK: - Configuration
    func configure<U>(with value: U, indexPath: IndexPath) where U: Hashable {
        guard let month = value as? MonthModel else { return }
        
        self.indexPath = indexPath
        nameMonthViewLabel.text = month.monthName
        setupConstraints()
        getMonthArray(monthArray: month.monthArray)
    }

    // MARK: - Private Methods
    private func setupViews() {
        addSubview(mainMonthView)
        mainMonthView.addSubview(nameMonthViewLabel)
        mainMonthView.addSubview(monthView)
        mainMonthView.frame = self.bounds
        
    }
    
    private func setupConstraints() {
        nameMonthViewLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(20)
        }
        
        monthView.snp.makeConstraints { make in
            make.top.equalTo(nameMonthViewLabel.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func relocateLabel(completion: @escaping () -> Void) {
        layoutIfNeeded()
        UIView.animate(withDuration: 0.3, animations: {
            self.nameMonthViewLabel.snp.remakeConstraints { make in
                make.top.trailing.equalToSuperview()
                make.height.equalTo(20)
            }
            self.layoutIfNeeded()
        }, completion: { _ in
            completion()
        })
    }
    
    private func getMonthArray(monthArray: [[Int]]) {
        let squareSize: CGFloat = bounds.width / 7.35
        let spacing: CGFloat = 1

        for i in 0..<6 {
            for j in 0..<7 {
                let x = CGFloat(j) * (squareSize + spacing)
                let y = CGFloat(i) * (squareSize + spacing)
                
                let square = CATextLayer()
                if monthArray[i][j] != 0 {
                    square.string = String(monthArray[i][j])
                }
                square.fontSize = squareSize / 2
                square.alignmentMode = .center
                square.foregroundColor = UIColor.white.cgColor
                square.contentsScale = UIScreen.main.scale
                square.frame = CGRect(x: x, y: y, width: squareSize, height: squareSize)
                
                monthDatesLayer.addSublayer(square)
            }
        }
        
        monthView.layer.addSublayer(monthDatesLayer)
    }
}