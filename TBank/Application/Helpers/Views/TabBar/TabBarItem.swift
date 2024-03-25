import UIKit
import SnapKit

enum TypeTabBar {
    case left
    case center
    case right
}

protocol TabBarItemDelegate: AnyObject {
    func leftItemTapped(_ cell: TabBarItem)
    func centerItemTapped(_ cell: TabBarItem)
    func rightItemTapped(_ cell: TabBarItem)
}

final class TabBarItem: UIView {
    
    // MARK: - Public Property
    weak var delegate: TabBarItemDelegate?
    
    // MARK: - Private Property
    private let leftItem = UIImageView()
    private let centerItem = UIImageView()
    private let rightItem = UIImageView()
    private let leftImageView = UIImageView(image: .Image.TabBar.leftItem)
    private let centerImageView = UIImageView(image: .Image.TabBar.centerItemDisabled)
    private let rightImageView = UIImageView(image: .Image.TabBar.rightItemDisabled)
    private let backgroundView = UIView()
    
    // MARK: - Init
    init() {
        super.init(frame: .zero)
        
        addSubviews()
        configureConstraints()
        configureUI()
        bind()
        createTabBarItemImage(leftItemColor: UIColor(resource: .Color.TabBar.selectedItem), centerItemColor: UIColor(resource: .Color.TabBar.disabledItem), rightItemColor: UIColor(resource: .Color.TabBar.disabledItem))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    private func addSubviews() {
        addSubview(backgroundView)
        addSubview(leftItem)
        leftItem.addSubview(leftImageView)
        addSubview(rightItem)
        rightItem.addSubview(rightImageView)
        addSubview(centerItem)
        centerItem.addSubview(centerImageView)
    }
    
    private func configureConstraints() {
        snp.makeConstraints { make in
            make.height.equalTo(75)
        }
        
        leftItem.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(30)
            make.centerY.equalToSuperview()
            make.width.equalTo(150)
            make.height.equalTo(75)
        }
        
        leftImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(30)
            make.width.equalTo(35)
            make.height.equalTo(35)
        }
        
        centerItem.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(18)
        }
        
        centerImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(35)
            make.height.equalTo(35)
        }
        
        rightItem.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-15)
            make.centerY.equalToSuperview()
            make.width.equalTo(150)
            make.height.equalTo(75)
        }
        
        rightImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(45)
            make.width.equalTo(35)
            make.height.equalTo(35)
        }
        
        backgroundView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(55)
        }
    }
    
    private func configureUI() {
        leftImageView.contentMode = .scaleAspectFit
        centerImageView.contentMode = .scaleAspectFit
        rightImageView.contentMode = .scaleAspectFit
        
        backgroundView.backgroundColor = UIColor(resource: .Color.backgroundColorView)
    }
    
    private func bind() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(leftItemTapped))
        leftItem.isUserInteractionEnabled = true
        leftItem.addGestureRecognizer(tapGesture)
        
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(centerItemTapped))
        centerItem.isUserInteractionEnabled = true
        centerItem.addGestureRecognizer(tapGesture2)
        
        let tapGesture3 = UITapGestureRecognizer(target: self, action: #selector(rightItemTapped))
        rightItem.isUserInteractionEnabled = true
        rightItem.addGestureRecognizer(tapGesture3)
    }
    
    @objc private func leftItemTapped() {
        delegate?.leftItemTapped(self)
    }
    
    @objc private func centerItemTapped() {
        delegate?.centerItemTapped(self)
    }
    
    @objc private func rightItemTapped() {
        delegate?.rightItemTapped(self)
    }
    
    private func createTabBarItemImage(leftItemColor: UIColor, centerItemColor: UIColor, rightItemColor: UIColor) {
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 115, y: 0))
        path.addLine(to: CGPoint(x: 65, y: 0))
        path.addQuadCurve(to: CGPoint(x: 40, y: 22), controlPoint: CGPoint(x: 45, y: 5))
        path.addQuadCurve(to: CGPoint(x: 12, y: 65), controlPoint: CGPoint(x: 30, y: 55))
        path.addQuadCurve(to: CGPoint(x: 20, y: 75), controlPoint: CGPoint(x: 5, y: 75))
        path.addLine(to: CGPoint(x: 115, y: 75))
        path.addQuadCurve(to: CGPoint(x: 135, y: 52), controlPoint: CGPoint(x: 135, y: 75))
        path.addLine(to: CGPoint(x: 135, y: 20))
        path.addQuadCurve(to: CGPoint(x: 115, y: 0), controlPoint: CGPoint(x: 135, y: 0))
        path.close()
        
        let path2 = UIBezierPath()
        path2.move(to: CGPoint(x: 23, y: 0))
        path2.addQuadCurve(to: CGPoint(x: 92, y: 0), controlPoint: CGPoint(x: 57, y: 10))
        path2.addQuadCurve(to: CGPoint(x: 115, y: 35), controlPoint: CGPoint(x: 115, y: 0))
        path2.addQuadCurve(to: CGPoint(x: 92, y: 72), controlPoint: CGPoint(x: 115, y: 70))
        path2.addQuadCurve(to: CGPoint(x: 23, y: 72), controlPoint: CGPoint(x: 57, y: 75))
        path2.addQuadCurve(to: CGPoint(x: 0, y: 35), controlPoint: CGPoint(x: 0, y: 70))
        path2.addQuadCurve(to: CGPoint(x: 23, y: 0), controlPoint: CGPoint(x: 0, y: 0))
        path2.close()
        
        let path3 = UIBezierPath()
        path3.move(to: CGPoint(x: 20, y: 0))
        path3.addLine(to: CGPoint(x: 70, y: 0))
        path3.addQuadCurve(to: CGPoint(x: 95, y: 22), controlPoint: CGPoint(x: 90, y: 5))
        path3.addQuadCurve(to: CGPoint(x: 123, y: 65), controlPoint: CGPoint(x: 105, y: 55))
        path3.addQuadCurve(to: CGPoint(x: 115, y: 75), controlPoint: CGPoint(x: 130, y: 75))
        path3.addLine(to: CGPoint(x: 20, y: 75))
        path3.addQuadCurve(to: CGPoint(x: 0, y: 52), controlPoint: CGPoint(x: 0, y: 75))
        path3.addLine(to: CGPoint(x: 0, y: 20))
        path3.addQuadCurve(to: CGPoint(x: 20, y: 0), controlPoint: CGPoint(x: 0, y: 0))
        path3.close()
        
        let tabBarItemImage = UIGraphicsImageRenderer(size: CGSize(width: 150, height: 75)).image { context in
            rightItemColor.setFill()
            path.fill()
        }

        let tabBarItemImage2 = UIGraphicsImageRenderer(size: CGSize(width: 115, height: 75)).image { context in
            centerItemColor.setFill()
            path2.fill()
        }
        
        let tabBarItemImage3 = UIGraphicsImageRenderer(size: CGSize(width: 150, height: 75)).image { context in
            leftItemColor.setFill()
            path3.fill()
        }
        
        rightItem.image = tabBarItemImage
        centerItem.image = tabBarItemImage2
        leftItem.image = tabBarItemImage3
    }
    
    func selected(_ typeTabBar: TypeTabBar) {
        switch typeTabBar {
        case .left:
            createTabBarItemImage(leftItemColor: UIColor(resource: .Color.TabBar.selectedItem), centerItemColor: UIColor(resource: .Color.TabBar.disabledItem), rightItemColor: UIColor(resource: .Color.TabBar.disabledItem))
            leftImageView.image = UIImage(resource: .Image.TabBar.leftItem)
            rightImageView.image = UIImage(resource: .Image.TabBar.rightItemDisabled)
        case .center:
            break
        case .right:
            createTabBarItemImage(leftItemColor: UIColor(resource: .Color.TabBar.disabledItem), centerItemColor: UIColor(resource: .Color.TabBar.disabledItem), rightItemColor: UIColor(resource: .Color.TabBar.selectedItem))
            leftImageView.image = UIImage(resource: .Image.TabBar.leftItemDisabled)
            rightImageView.image = UIImage(resource: .Image.TabBar.rightItem)
        }
    }
    
}
