import UIKit
import SnapKit

final class LocalizedCurrencyRatesViewController: UIViewController {
    
    // MARK: - Public Properties
    var viewModel: LocalizedCurrencyRatesViewModel!
    
    private let titleLabel = UILabel()
    private let setupButton = UIButton()
    private let сurrencyButton = UIButton()
    
    
    // MARK: - LyfeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addSubviews()
        configureConstraints()
        configureUI()
        fetchExchangeRates()
    }
    
    // MARK: - Methods
    private func addSubviews() {
        view.addSubview(titleLabel)
        view.addSubview(setupButton)
        view.addSubview(сurrencyButton)
    }
    
    private func configureConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 80).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        setupButton.translatesAutoresizingMaskIntoConstraints = false
        setupButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        setupButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -26).isActive = true

        сurrencyButton.translatesAutoresizingMaskIntoConstraints = false
        сurrencyButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        сurrencyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 26).isActive = true
    }
    
    private func configureUI() {
        titleLabel.text = NSLocalizedString("App.LocalizedCurrencyRates.NavigationItemTitle", comment: "")
        titleLabel.textColor = .black
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        
        setupButton.tintColor = .black
        setupButton.setImage(UIImage(systemName: "gearshape"), for: .normal)
        let symbolConfigurationSetup = UIImage.SymbolConfiguration(pointSize: 25)
        setupButton.setPreferredSymbolConfiguration(symbolConfigurationSetup, forImageIn: .normal)
        setupButton.addTarget(self, action: #selector(tapOnSetupButton), for: .touchUpInside)
        
        сurrencyButton.tintColor = .black
        сurrencyButton.setTitle("USD", for: .normal)
        сurrencyButton.setTitleColor(.black, for: .normal)
        сurrencyButton.titleLabel?.font = UIFont.systemFont(ofSize: 24)
        сurrencyButton.addTarget(self, action: #selector(tapOnCurrencyButton), for: .touchUpInside)
    }
    
    private func showCurrencySelectionActionSheet() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        for currencyRate in viewModel.currencyRates {
            let action = UIAlertAction(title: currencyRate.abbreviation, style: .default) { [weak self] _ in
                self?.handleCurrencySelection(currencyRate)
            }
            actionSheet.addAction(action)
        }
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
        actionSheet.addAction(cancelAction)
        
        if let popoverController = actionSheet.popoverPresentationController {
            popoverController.sourceView = сurrencyButton
            popoverController.sourceRect = сurrencyButton.bounds
        }
        present(actionSheet, animated: true, completion: nil)
    }

    private func fetchExchangeRates() {
        viewModel.fetchExchangeRates { [weak self] error in
            if let error = error {
                print("Failed to fetch exchange rates: \(error)")
            } else {
                self?.reloadCurrencyButton()
            }
        }
    }
    
    private func handleCurrencySelection(_ currencyRate: CurrencyRate) {
        print("Selected currency abbreviation: \(currencyRate.abbreviation)")
        сurrencyButton.setTitle(currencyRate.abbreviation, for: .normal)
    }
        
    private func reloadCurrencyButton() {
        if let currencyRate = viewModel.currencyRates.first {
            сurrencyButton.setTitle(currencyRate.abbreviation, for: .normal)
        }
    }
    
    @objc func tapOnSetupButton() {
        print("update")
    }
    
    @objc func tapOnCurrencyButton() {
        print("tapOnCurrencyButton")
        showCurrencySelectionActionSheet()
    }
}
