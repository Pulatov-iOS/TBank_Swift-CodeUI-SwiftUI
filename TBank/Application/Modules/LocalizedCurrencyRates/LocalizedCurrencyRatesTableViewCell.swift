import UIKit

final class LocalizedCurrencyRatesTableViewCell: UITableViewCell {
    
    //MARK: - Privat Properties
    private enum DynamicType {
        case positive
        case negative
    }

    private let backgroundBaseView = UIView()
    private let currencyStackView = UIStackView()
    private let currencyNameLabel = UILabel()
    private let currencyChangeRatingStackView = UIStackView()
    private let avrLabel = UILabel()
    private let avrCountLabel = UILabel()
    private let avrDynamicImageView = UIImageView()
    private let mapImageView = UIImageView()
    private let rateLabel = UILabel()
    private var dynamicStatus: DynamicType = .negative
    
    //MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubviews()
        setConstraintes()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Methods
    private func addSubviews() {
        contentView.addSubviews(with: backgroundBaseView)
        backgroundBaseView.addSubviews(with: currencyStackView, rateLabel, mapImageView, avrLabel, avrCountLabel)
        currencyStackView.addArrangedSubviews(with: currencyNameLabel)
        currencyChangeRatingStackView.addArrangedSubviews(with: avrDynamicImageView)
    }

    private func setConstraintes() {
        backgroundBaseView.translatesAutoresizingMaskIntoConstraints = false
        backgroundBaseView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        backgroundBaseView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24).isActive = true
        backgroundBaseView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24).isActive = true
        backgroundBaseView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        
        mapImageView.translatesAutoresizingMaskIntoConstraints = false
        mapImageView.centerYAnchor.constraint(equalTo: backgroundBaseView.centerYAnchor).isActive = true
        mapImageView.leadingAnchor.constraint(equalTo: backgroundBaseView.leadingAnchor, constant: 20).isActive = true
        mapImageView.widthAnchor.constraint(equalToConstant: 28).isActive = true
        mapImageView.heightAnchor.constraint(equalToConstant: 28).isActive = true
        
        currencyStackView.translatesAutoresizingMaskIntoConstraints = false
        currencyStackView.topAnchor.constraint(equalTo: backgroundBaseView.topAnchor, constant: 18).isActive = true
        currencyStackView.leadingAnchor.constraint(equalTo: mapImageView.trailingAnchor, constant: 8).isActive = true
        currencyStackView.widthAnchor.constraint(equalTo: backgroundBaseView.widthAnchor, multiplier: 0.52).isActive = true
        
        avrLabel.translatesAutoresizingMaskIntoConstraints = false
        avrLabel.topAnchor.constraint(equalTo: currencyStackView.bottomAnchor, constant: 5).isActive = true
        avrLabel.leadingAnchor.constraint(equalTo: mapImageView.trailingAnchor, constant: 8).isActive = true
        
        avrCountLabel.translatesAutoresizingMaskIntoConstraints = false
        avrCountLabel.centerYAnchor.constraint(equalTo: avrLabel.centerYAnchor).isActive = true
        avrCountLabel.leadingAnchor.constraint(equalTo: avrLabel.trailingAnchor, constant: 8).isActive = true
        
        avrDynamicImageView.translatesAutoresizingMaskIntoConstraints = false
        avrDynamicImageView.widthAnchor.constraint(equalToConstant: 5).isActive = true
        avrDynamicImageView.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        rateLabel.translatesAutoresizingMaskIntoConstraints = false
        rateLabel.centerYAnchor.constraint(equalTo: backgroundBaseView.centerYAnchor).isActive = true
        rateLabel.trailingAnchor.constraint(equalTo: backgroundBaseView.trailingAnchor, constant: -24).isActive = true
    }
    
    private func configureUI() {
        backgroundBaseView.backgroundColor = UIColor(resource: .Color.backgroundColorItem)
        backgroundBaseView.layer.cornerRadius = 40
        backgroundBaseView.layer.borderColor = UIColor.black.cgColor
        backgroundBaseView.layer.borderWidth = 0
        backgroundBaseView.layer.shadowColor = UIColor.black.cgColor
        backgroundBaseView.layer.shadowOffset = CGSize(width: 0, height: 2)
        backgroundBaseView.layer.shadowRadius = 5
        backgroundBaseView.layer.shadowOpacity = 0.20
        
        currencyStackView.axis = .vertical
        currencyStackView.distribution = .fillProportionally
        currencyStackView.spacing = 5
        
        currencyNameLabel.textAlignment = .left
        currencyNameLabel.font = UIFont.manrope(ofSize: 15, style: .medium)
        currencyNameLabel.text = "USD"

        avrLabel.textAlignment = .left
        avrLabel.font = UIFont.manrope(ofSize: 13, style: .medium)
        avrLabel.text = "Пн - Пт"
        
        avrCountLabel.textAlignment = .left
        avrCountLabel.textColor = .lightGray
        avrCountLabel.font = UIFont.manrope(ofSize: 13, style: .medium)
        avrCountLabel.text = "9:00 - 18:00"
        
        let originalImage = UIImage(resource: .Image.LocalizedCurrencyRates.BranchDetails.ExchangeRates.map)
        let tintedImage = originalImage.withTintColor(UIColor(resource: .Color.textColorTitel))
        mapImageView.image = tintedImage
    
        rateLabel.textAlignment = .left
        rateLabel.font = UIFont.manrope(ofSize: 20, style: .medium)
        rateLabel.attributedText = setAttributedString(with: "3.24 byn", dynamicStatus)
    }
    
    private func setAttributedString(with text: String, _ avrDynamic: DynamicType) -> NSAttributedString {
        let text = text
        let attributedString = NSMutableAttributedString(string: text)
        let rateNumbersColor = avrDynamic == .positive ? UIColor(resource: .Color.LocalizedCurrencyRates.BranchDetails.ExchangeRates.customGreenER).cgColor : UIColor.red.cgColor
        attributedString.addAttribute(.foregroundColor, value: rateNumbersColor, range: NSRange(location: 0, length: 4))
        return attributedString
    }
    
    func setInformation(bankBranchesSubject: BankBranch, rate: Double) {
        currencyNameLabel.text = NSLocalizedString("App.Addresses.\(bankBranchesSubject.address ?? "")", comment: "")
        rateLabel.text = String(format:"%.2f" + " BYN",(rate))
    }
}
