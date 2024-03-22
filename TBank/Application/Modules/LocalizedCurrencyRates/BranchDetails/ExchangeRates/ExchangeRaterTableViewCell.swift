
import UIKit

//MARK: - Final class ClassExchangeRatesTableViewCell

final class ExchangeRatesTableViewCell: UITableViewCell {
    
    
//MARK: - Properties of class
    
    private let backgroundBaseView = UIView()
    private let currencyStackView = UIStackView()
    private let currencyNameLabel = UILabel()
    private let currencyChangeRatingStackView = UIStackView()
    private let avrLabel = UILabel()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubviews()
        setConstraintes()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
  
    
//MARK: - Adding of subViews
        
    private func addSubviews() {
        
        contentView.addSubviews(with: backgroundBaseView)
        backgroundBaseView.addSubview(currencyStackView)
        currencyStackView.addArrangedSubviews(with: currencyNameLabel, currencyChangeRatingStackView)
        currencyChangeRatingStackView.addArrangedSubviews(with: avrLabel)
    }
    
    
    
//MARK: - Setting of constraintes
    
    private func setConstraintes() {
        
        backgroundBaseView.translatesAutoresizingMaskIntoConstraints = false
        backgroundBaseView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12).isActive = true
        backgroundBaseView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 7).isActive = true
        backgroundBaseView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -7).isActive = true
        backgroundBaseView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        currencyStackView.translatesAutoresizingMaskIntoConstraints = false
        currencyStackView.topAnchor.constraint(equalTo: backgroundBaseView.topAnchor, constant: 5).isActive = true
        currencyStackView.leadingAnchor.constraint(equalTo: backgroundBaseView.leadingAnchor, constant: 5).isActive = true
        currencyStackView.bottomAnchor.constraint(equalTo: backgroundBaseView.bottomAnchor, constant: -5).isActive = true
        currencyStackView.widthAnchor.constraint(equalTo: backgroundBaseView.widthAnchor, multiplier: 0.33).isActive = true

    }
    
    
    
    //MARK: - Configuration of User Interface
    
    private func configureUI() {
        
        backgroundBaseView.backgroundColor = .systemGray6
        backgroundBaseView.layer.cornerRadius = 5
        backgroundBaseView.layer.borderColor = UIColor.black.cgColor
        backgroundBaseView.layer.borderWidth = 2
        
        currencyStackView.axis = .vertical
        currencyStackView.distribution = .fillProportionally
        currencyStackView.spacing = 3
        currencyStackView.alignment = .leading
        
        currencyNameLabel.textAlignment = .left
        currencyNameLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        currencyNameLabel.text = "USD"
        
        currencyChangeRatingStackView.axis = .horizontal
        currencyStackView.distribution = .fillProportionally
        currencyStackView.spacing = 3
        
        avrLabel.textAlignment = .left
        avrLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        avrLabel.text = "Avr."
    }
}



//MARK: - Implemendation of AddNewInfoInterractorInputProtocol protocol for AddNewInfoInterractor class

