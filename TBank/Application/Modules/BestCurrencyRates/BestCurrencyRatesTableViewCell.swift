import UIKit

final class BestCurrencyRatesTableViewCell: UITableViewCell {
    
    // MARK: - UI Elements
    private let customView = UIView()
    private let nameLabel = UILabel()
    private let priceLabel = UILabel()
    private let scaleLabel = UILabel()
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        configureUI()
        configureConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - UI Setup
    private func addSubviews() {
        contentView.addSubview(customView)
        customView.addSubview(nameLabel)
        customView.addSubview(priceLabel)
        customView.addSubview(scaleLabel)
    }
    
    private func configureConstraints() {
        customView.translatesAutoresizingMaskIntoConstraints = false
        customView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        customView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        customView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        customView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5).isActive = true
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.centerYAnchor.constraint(equalTo: customView.centerYAnchor).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: customView.leadingAnchor, constant: 17).isActive = true
        
        
        scaleLabel.translatesAutoresizingMaskIntoConstraints = false
        scaleLabel.centerYAnchor.constraint(equalTo: customView.centerYAnchor).isActive = true
        scaleLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 10).isActive = true
        
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.centerYAnchor.constraint(equalTo: customView.centerYAnchor).isActive = true
        priceLabel.trailingAnchor.constraint(equalTo: customView.trailingAnchor, constant: -17).isActive = true
    }
    
    private func configureUI() {
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = .white
    
        customView.layer.borderWidth = 2.0
        customView.layer.borderColor = UIColor.black.cgColor
        customView.layer.cornerRadius = 5
        customView.backgroundColor = .white
        
        nameLabel.textColor = .black
        nameLabel.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        
        priceLabel.textColor = .black
        priceLabel.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        
        scaleLabel.textColor = .black
        scaleLabel.font = UIFont.systemFont(ofSize: 25, weight: .light)
    }
    
    // MARK: - Configuration
    
    func setInformation(with rate: CurrencyRateDTO) {
        nameLabel.text = rate.abbreviation
        priceLabel.text = String(format: "%.2f" + " BYN", rate.rate)
        scaleLabel.text = String(format: "%.0f", rate.scale)
    }
}
