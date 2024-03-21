import UIKit
import SnapKit

final class LocalizedCurrencyRatesViewController: UIViewController {
    
    // MARK: - Public Properties
    var viewModel: LocalizedCurrencyRatesViewModel!
    
    private let titleLabel = UILabel()
    private let setupButton = UIButton()
    
    // MARK: - LyfeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addSubviews()
        configureConstraints()
        configureUI()
        bindings()
    }
    
    // MARK: - Methods
    private func addSubviews() {
        view.addSubview(titleLabel)
        view.addSubview(setupButton)
    }
    
    private func configureConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 80).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        setupButton.translatesAutoresizingMaskIntoConstraints = false
        setupButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        setupButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -26).isActive = true
    }
    
    private func configureUI() {
        titleLabel.text = NSLocalizedString("App.LocalizedCurrencyRates.NavigationItemTitle", comment: "")
        titleLabel.textColor = .black
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        
        setupButton.tintColor = .black
        setupButton.setImage(UIImage(systemName: "gearshape"), for: .normal)
        let symbolConfigurationAdd = UIImage.SymbolConfiguration(pointSize: 25)
        setupButton.setPreferredSymbolConfiguration(symbolConfigurationAdd, forImageIn: .normal)
        setupButton.addTarget(self, action: #selector(tapOnSetupButton), for: .touchUpInside)
    }
    
    @objc func tapOnSetupButton() {
        print("update")
    }
    
    private func bindings() {
        
    }
    
}
