import UIKit

final class ExchangeRatesTableViewCell: UITableViewCell {

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
        customView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24).isActive = true
        customView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24).isActive = true
        customView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.centerYAnchor.constraint(equalTo: customView.centerYAnchor).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: customView.leadingAnchor, constant: 24).isActive = true
        
        scaleLabel.translatesAutoresizingMaskIntoConstraints = false
        scaleLabel.centerYAnchor.constraint(equalTo: customView.centerYAnchor).isActive = true
        scaleLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 10).isActive = true
        
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.centerYAnchor.constraint(equalTo: customView.centerYAnchor).isActive = true
        priceLabel.trailingAnchor.constraint(equalTo: customView.trailingAnchor, constant: -24).isActive = true
    }
    
    private func configureUI() {
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = UIColor(resource: .Color.backgroundColorView)
    
        customView.layer.cornerRadius = 40
        customView.backgroundColor = UIColor(resource: .Color.backgroundColorItem)
        customView.layer.shadowColor = UIColor.black.cgColor
        customView.layer.shadowOffset = CGSize(width: 0, height: 2)
        customView.layer.shadowRadius = 5
        customView.layer.shadowOpacity = 0.20

        nameLabel.textColor = UIColor(resource: .Color.textColorTitel)
        nameLabel.font = UIFont.manrope(ofSize: 20, style: .regular)
        
        priceLabel.textColor = UIColor(resource: .Color.textColorTitel)
        priceLabel.font = UIFont.manrope(ofSize: 20, style: .regular)
        
        scaleLabel.textColor = UIColor(resource: .Color.textColorTitel)
        scaleLabel.font = UIFont.manrope(ofSize: 20, style: .regular)
    }
    
    // MARK: - Configuration
    
    func setInformation(with rate: BankBranchCurrencyRate) {
        nameLabel.text = rate.abbreviation
        priceLabel.text = String(format: "%.2f" + " BYN", rate.rate)
        scaleLabel.text = String(format: "%.0f", rate.scale)
    }
}
