import UIKit
import Combine

class CurrencyConverterViewController: UIViewController {
    
    var viewModel = CurrencyConverterViewModel()
    var cancallables = Set<AnyCancellable>()
    
    let converterTitleLabel = UILabel()
    let firstCurrencyView = UIView()
    let secondCurrencyView = UIView()
    let changeCurrencyButton = UIButton()
    let currencyButtonForFirstView = UIButton(type: .system)
    let amountTextFieldForFirstView = UITextField()
    let currencyButtonForSecondView = UIButton(type: .system)
    let conversionResult = UILabel()
    let littleView1 = UIView()
    let littleView2 = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        addSubviews()
        constraints()
        configureUI()
        amountTextFieldForFirstView.addTarget(self, action: #selector(editingChanged), for: .allEditingEvents)
        
        bindings()
    }

    func addSubviews() {
        view.addSubview(converterTitleLabel)
        
        view.addSubview(firstCurrencyView)
        firstCurrencyView.addSubview(currencyButtonForFirstView)
        firstCurrencyView.addSubview(amountTextFieldForFirstView)
        firstCurrencyView.addSubview(littleView1)
        
        view.addSubview(changeCurrencyButton)
        
        view.addSubview(secondCurrencyView)
        secondCurrencyView.addSubview(currencyButtonForSecondView)
        secondCurrencyView.addSubview(conversionResult)
        secondCurrencyView.addSubview(littleView2)
    }
    
    func constraints() {
        converterTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        converterTitleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 120).isActive = true
        converterTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 21).isActive = true
        converterTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -21).isActive = true
        converterTitleLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        firstCurrencyView.translatesAutoresizingMaskIntoConstraints = false
        firstCurrencyView.topAnchor.constraint(equalTo: converterTitleLabel.bottomAnchor, constant: 90).isActive = true
        firstCurrencyView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 31).isActive = true
        firstCurrencyView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -31).isActive = true
        firstCurrencyView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        currencyButtonForFirstView.translatesAutoresizingMaskIntoConstraints = false
        currencyButtonForFirstView.leadingAnchor.constraint(equalTo: firstCurrencyView.leadingAnchor, constant: 20).isActive = true
        currencyButtonForFirstView.centerYAnchor.constraint(equalTo: firstCurrencyView.centerYAnchor).isActive = true
        
        amountTextFieldForFirstView.translatesAutoresizingMaskIntoConstraints = false
        amountTextFieldForFirstView.trailingAnchor.constraint(equalTo: firstCurrencyView.trailingAnchor, constant: -30).isActive = true
        amountTextFieldForFirstView.centerYAnchor.constraint(equalTo: firstCurrencyView.centerYAnchor).isActive = true
        amountTextFieldForFirstView.widthAnchor.constraint(greaterThanOrEqualToConstant: 60).isActive = true
        
        littleView1.translatesAutoresizingMaskIntoConstraints = false
        littleView1.trailingAnchor.constraint(equalTo: firstCurrencyView.trailingAnchor, constant: -30).isActive = true
        littleView1.topAnchor.constraint(equalTo: amountTextFieldForFirstView.bottomAnchor, constant: 2).isActive = true
        littleView1.widthAnchor.constraint(equalTo: amountTextFieldForFirstView.widthAnchor).isActive = true
        littleView1.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        
        changeCurrencyButton.translatesAutoresizingMaskIntoConstraints = false
        changeCurrencyButton.topAnchor.constraint(equalTo: firstCurrencyView.bottomAnchor, constant: 25).isActive = true
        changeCurrencyButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        changeCurrencyButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        changeCurrencyButton.heightAnchor.constraint(equalToConstant: 35).isActive = true

        secondCurrencyView.translatesAutoresizingMaskIntoConstraints = false
        secondCurrencyView.topAnchor.constraint(equalTo: changeCurrencyButton.bottomAnchor, constant: 25).isActive = true
        secondCurrencyView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 31).isActive = true
        secondCurrencyView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -31).isActive = true
        secondCurrencyView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        currencyButtonForSecondView.translatesAutoresizingMaskIntoConstraints = false
        currencyButtonForSecondView.leadingAnchor.constraint(equalTo: secondCurrencyView.leadingAnchor, constant: 20).isActive = true
        currencyButtonForSecondView.centerYAnchor.constraint(equalTo: secondCurrencyView.centerYAnchor).isActive = true
        
        conversionResult.translatesAutoresizingMaskIntoConstraints = false
        conversionResult.trailingAnchor.constraint(equalTo: secondCurrencyView.trailingAnchor, constant: -30).isActive = true
        conversionResult.centerYAnchor.constraint(equalTo: secondCurrencyView.centerYAnchor).isActive = true
        conversionResult.widthAnchor.constraint(greaterThanOrEqualToConstant: 60).isActive = true
        
        littleView2.translatesAutoresizingMaskIntoConstraints = false
        littleView2.trailingAnchor.constraint(equalTo: secondCurrencyView.trailingAnchor, constant: -30).isActive = true
        littleView2.topAnchor.constraint(equalTo: conversionResult.bottomAnchor, constant: 2).isActive = true
        littleView2.widthAnchor.constraint(equalTo: conversionResult.widthAnchor).isActive = true
        littleView2.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    func configureUI() {
        converterTitleLabel.text = NSLocalizedString("App.CurrencyConverter.NavigationItemTitle", comment: "")
        converterTitleLabel.textAlignment = .center
        converterTitleLabel.font = UIFont.manrope(ofSize: 25, style: .bold)
        
        firstCurrencyView.backgroundColor = .white
        firstCurrencyView.layer.cornerRadius = 35
        firstCurrencyView.layer.shadowOffset = CGSize(width: 0, height: 2)
        firstCurrencyView.layer.shadowColor = UIColor.black.cgColor
        firstCurrencyView.layer.shadowRadius = 1
        firstCurrencyView.layer.shadowOpacity = 0.1
        
        amountTextFieldForFirstView.textAlignment = .center
        conversionResult.textAlignment = .center
        conversionResult.text = " "
        
        littleView1.backgroundColor = .black
        littleView2.backgroundColor = .black
        
        let configurationForChangeCurrencyButton = UIImage.SymbolConfiguration(pointSize: 40, weight: .semibold, scale: .medium)
        let imageForChangeCurrencyButton = UIImage(systemName: "arrow.up.arrow.down", withConfiguration: configurationForChangeCurrencyButton)
        changeCurrencyButton.setImage(imageForChangeCurrencyButton, for: .normal)
        changeCurrencyButton.tintColor = .orange
        
        secondCurrencyView.backgroundColor = .white
        secondCurrencyView.layer.cornerRadius = 35
        secondCurrencyView.layer.shadowOffset = CGSize(width: 0, height: 2)
        secondCurrencyView.layer.shadowColor = UIColor.black.cgColor
        secondCurrencyView.layer.shadowRadius = 1
        secondCurrencyView.layer.shadowOpacity = 0.1
        
        currencyButtonForFirstView.setTitle("USD", for: .normal)
        currencyButtonForFirstView.titleLabel?.font = .systemFont(ofSize: 21, weight: .semibold)
        currencyButtonForFirstView.setTitleColor(.label, for: .normal)
        currencyButtonForSecondView.setTitle("BYN", for: .normal)
        currencyButtonForSecondView.titleLabel?.font = .systemFont(ofSize: 21, weight: .semibold)
        currencyButtonForSecondView.setTitleColor(.black, for: .normal)
    }
    
    private func bindings() {
        viewModel.amountForChangeSubject
            .sink { [weak self] convertResult in
                self?.conversionResult.text = "\(convertResult)"
            }
            .store(in: &cancallables)
    }
    
    @objc func editingChanged() {
        viewModel.changeTextField(enteredAmount: amountTextFieldForFirstView.text ?? "")
    }
}



