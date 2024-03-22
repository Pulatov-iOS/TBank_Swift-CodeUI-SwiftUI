
import UIKit

enum DynamicType {
    case positive
    case negative
}



//MARK: - Final class ClassExchangeRatesTableViewCell

final class ExchangeRatesTableViewCell: UITableViewCell {
    
    
//MARK: - Properties of class
    
    private let backgroundBaseView = UIView()
    private let currencyStackView = UIStackView()
    private let currencyNameLabel = UILabel()
    private let currencyChangeRatingStackView = UIStackView()
    private let avrLabel = UILabel()
    private let avrCountLabel = UILabel()
    private let avrDynamicImageView = UIImageView()
    private let rateLabel = UILabel()
    
    private var dynamicStatus: DynamicType = .negative
    
   
    
//MARK: - Initializator
    
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
        backgroundBaseView.addSubviews(with: currencyStackView, rateLabel)
        currencyStackView.addArrangedSubviews(with: currencyNameLabel, currencyChangeRatingStackView)
        currencyChangeRatingStackView.addArrangedSubviews(with: avrLabel, avrCountLabel, avrDynamicImageView)
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
        currencyStackView.leadingAnchor.constraint(equalTo: backgroundBaseView.leadingAnchor, constant: 10).isActive = true
        currencyStackView.bottomAnchor.constraint(equalTo: backgroundBaseView.bottomAnchor, constant: -15).isActive = true
        currencyStackView.widthAnchor.constraint(equalTo: backgroundBaseView.widthAnchor, multiplier: 0.32).isActive = true
        
        avrDynamicImageView.translatesAutoresizingMaskIntoConstraints = false
        avrDynamicImageView.widthAnchor.constraint(equalToConstant: 5).isActive = true
        avrDynamicImageView.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        rateLabel.translatesAutoresizingMaskIntoConstraints = false
        rateLabel.topAnchor.constraint(equalTo: backgroundBaseView.topAnchor, constant: 5).isActive = true
        rateLabel.trailingAnchor.constraint(equalTo: backgroundBaseView.trailingAnchor, constant: -10).isActive = true
        rateLabel.bottomAnchor.constraint(equalTo: backgroundBaseView.bottomAnchor, constant: -15).isActive = true
        rateLabel.widthAnchor.constraint(equalTo: backgroundBaseView.widthAnchor, multiplier: 0.32).isActive = true
    }
    
    
    
    //MARK: - Configuration of User Interface
    
    private func configureUI() {
        
        backgroundBaseView.backgroundColor = .systemGray6
        backgroundBaseView.layer.cornerRadius = 10
        backgroundBaseView.layer.borderColor = UIColor.black.cgColor
        backgroundBaseView.layer.borderWidth = 1
        
        currencyStackView.axis = .vertical
        currencyStackView.distribution = .fillProportionally
        currencyStackView.spacing = 5
        
        currencyNameLabel.textAlignment = .left
        currencyNameLabel.font = UIFont.manrope(ofSize: 24, style: .bold)
        currencyNameLabel.text = "USD"
        
        currencyChangeRatingStackView.axis = .horizontal
        currencyChangeRatingStackView.distribution = .fillEqually
        currencyChangeRatingStackView.spacing = 2
        
        avrLabel.textAlignment = .left
//        avrLabel.textColor = .black
        avrLabel.font = UIFont.manrope(ofSize: 17, style: .semiBold)
        avrLabel.text = "Avr."
        
        avrCountLabel.textAlignment = .left
        avrCountLabel.textColor = .lightGray
        avrCountLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        avrCountLabel.text = "3.24"
        
        avrDynamicImageView.image = dynamicStatus == .positive ? UIImage(named: "greenArrowUp") : UIImage(named: "redArrowDown")
        avrDynamicImageView.contentMode = .scaleAspectFit
        
        rateLabel.textAlignment = .left
//        rateLabel.textColor = .black
        rateLabel.font = UIFont.manrope(ofSize: 26, style: .extraBold)
        rateLabel.attributedText = setAttributedString(with: "3.24 byn", dynamicStatus)
    }
    
    private func setAttributedString(with text: String, _ avrDynamic: DynamicType) -> NSAttributedString {
        let text = text
        let attributedString = NSMutableAttributedString(string: text)
        let rateNumbersColor = avrDynamic == .positive ? UIColor.customGreenER.cgColor : UIColor.red.cgColor
        attributedString.addAttribute(.foregroundColor, value: rateNumbersColor, range: NSRange(location: 0, length: 4))
        return attributedString
    }
}



//MARK: - Implemendation of AddNewInfoInterractorInputProtocol protocol for AddNewInfoInterractor class

