import UIKit
import SnapKit

//MARK: - Final class SettingsViewController

final class SettingsViewController: UIViewController {
    
    // MARK: - Public Properties
    var viewModel: SettingsViewModel!

    private let titleLabel = UILabel()
    private let backButton = UIButton()

    private let termsOfUseView = UIView()
    private let privacyPolicyView = UIView()
    private let iconTermsImageView = UIImageView()
    private let iconPrivacyImageView = UIImageView()
    private let termsLabel = UILabel()
    private let privacyLabel = UILabel()
    private let termsNextArrowImageView = UIImageView()
    private let privacyNextArrowImageView = UIImageView()
    private let termsOfUseButton = UIButton()
    private let privacyPolicyButton = UIButton()
    
    // MARK: - LyfeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        configureConstraints()
        configureUI()
        bindings()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setCornerRadius()
    }
    
    // MARK: - Add subviews
    
    private func addSubviews() {
        view.addSubviews(with: titleLabel, backButton, termsOfUseView, privacyPolicyView)
        termsOfUseView.addSubviews(with: termsOfUseButton)
        privacyPolicyView.addSubviews(with: privacyPolicyButton)
        termsOfUseButton.addSubviews(with: termsLabel, termsNextArrowImageView, iconTermsImageView)
        privacyPolicyButton.addSubviews(with: privacyLabel, privacyNextArrowImageView, iconPrivacyImageView)
    }
    
    //MARK: - Configure constraintes
    
    private func configureConstraints() {
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 80).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 26).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        termsOfUseView.translatesAutoresizingMaskIntoConstraints = false
        termsOfUseView.topAnchor.constraint(equalTo: backButton.safeAreaLayoutGuide.bottomAnchor, constant: 30).isActive = true
        termsOfUseView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        termsOfUseView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        termsOfUseView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        iconTermsImageView.translatesAutoresizingMaskIntoConstraints = false
        iconTermsImageView.topAnchor.constraint(equalTo: termsOfUseView.topAnchor, constant: 5).isActive = true
        iconTermsImageView.leadingAnchor.constraint(equalTo: termsOfUseView.leadingAnchor, constant: 5).isActive = true
        iconTermsImageView.bottomAnchor.constraint(equalTo: termsOfUseView.bottomAnchor, constant: -5).isActive = true
        iconTermsImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        termsNextArrowImageView.translatesAutoresizingMaskIntoConstraints = false
        termsNextArrowImageView.topAnchor.constraint(equalTo: termsOfUseView.topAnchor, constant: 11).isActive = true
        termsNextArrowImageView.trailingAnchor.constraint(equalTo: termsOfUseView.trailingAnchor, constant: -11).isActive = true
        termsNextArrowImageView.bottomAnchor.constraint(equalTo: termsOfUseView.bottomAnchor, constant: -11).isActive = true
        termsNextArrowImageView.widthAnchor.constraint(equalToConstant: 28).isActive = true
        
        termsLabel.translatesAutoresizingMaskIntoConstraints = false
        termsLabel.topAnchor.constraint(equalTo: termsOfUseView.topAnchor, constant: 7).isActive = true
        termsLabel.leadingAnchor.constraint(equalTo: iconTermsImageView.trailingAnchor, constant: 10).isActive = true
        termsLabel.bottomAnchor.constraint(equalTo: termsOfUseView.bottomAnchor, constant: -7).isActive = true
        termsLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 125).isActive = true
        
        termsOfUseButton.translatesAutoresizingMaskIntoConstraints = false
        termsOfUseButton.topAnchor.constraint(equalTo: termsOfUseView.topAnchor).isActive = true
        termsOfUseButton.leadingAnchor.constraint(equalTo: termsOfUseView.leadingAnchor).isActive = true
        termsOfUseButton.trailingAnchor.constraint(equalTo: termsOfUseView.trailingAnchor).isActive = true
        termsOfUseButton.bottomAnchor.constraint(equalTo: termsOfUseView.bottomAnchor).isActive = true
        
        privacyPolicyView.translatesAutoresizingMaskIntoConstraints = false
        privacyPolicyView.topAnchor.constraint(equalTo: termsOfUseView.bottomAnchor, constant: 20).isActive = true
        privacyPolicyView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        privacyPolicyView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        privacyPolicyView.heightAnchor.constraint(equalToConstant: 50).isActive = true

        iconPrivacyImageView.translatesAutoresizingMaskIntoConstraints = false
        iconPrivacyImageView.topAnchor.constraint(equalTo: privacyPolicyView.topAnchor, constant: 5).isActive = true
        iconPrivacyImageView.leadingAnchor.constraint(equalTo: privacyPolicyView.leadingAnchor, constant: 5).isActive = true
        iconPrivacyImageView.bottomAnchor.constraint(equalTo: privacyPolicyView.bottomAnchor, constant: -5).isActive = true
        iconPrivacyImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        privacyNextArrowImageView.translatesAutoresizingMaskIntoConstraints = false
        privacyNextArrowImageView.topAnchor.constraint(equalTo: privacyPolicyView.topAnchor, constant: 11).isActive = true
        privacyNextArrowImageView.trailingAnchor.constraint(equalTo: privacyPolicyView.trailingAnchor, constant: -11).isActive = true
        privacyNextArrowImageView.bottomAnchor.constraint(equalTo: privacyPolicyView.bottomAnchor, constant: -11).isActive = true
        privacyNextArrowImageView.widthAnchor.constraint(equalToConstant: 28).isActive = true
        
        privacyLabel.translatesAutoresizingMaskIntoConstraints = false
        privacyLabel.topAnchor.constraint(equalTo: privacyPolicyView.topAnchor, constant: 7).isActive = true
        privacyLabel.leadingAnchor.constraint(equalTo: iconPrivacyImageView.trailingAnchor, constant: 10).isActive = true
        privacyLabel.bottomAnchor.constraint(equalTo: privacyPolicyView.bottomAnchor, constant: -7).isActive = true
        privacyLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 125).isActive = true
        
        privacyPolicyButton.translatesAutoresizingMaskIntoConstraints = false
        privacyPolicyButton.topAnchor.constraint(equalTo: privacyPolicyView.topAnchor).isActive = true
        privacyPolicyButton.leadingAnchor.constraint(equalTo: privacyPolicyView.leadingAnchor).isActive = true
        privacyPolicyButton.trailingAnchor.constraint(equalTo: privacyPolicyView.trailingAnchor).isActive = true
        privacyPolicyButton.bottomAnchor.constraint(equalTo: privacyPolicyView.bottomAnchor).isActive = true
    }
    
    //MARK: - Configure UI
    
    private func configureUI() {
        view.backgroundColor = UIColor(resource: .Color.backgroundColorView)

        titleLabel.text = NSLocalizedString("App.Settings.NavigationItemTitle", comment: "")
        titleLabel.textColor = UIColor(resource: .Color.textColorTitel)
        titleLabel.font = UIFont.manrope(ofSize: 24, style: .bold)
        
        backButton.backgroundColor = UIColor(resource: .Color.backgroundColorItem)
        backButton.adjustsImageWhenHighlighted = false
        backButton.tintColor = UIColor(resource: .Color.textColorTitel)
        let symbolConfigurationAdd = UIImage.SymbolConfiguration(pointSize: 28)
        backButton.setPreferredSymbolConfiguration(symbolConfigurationAdd, forImageIn: .normal)
        backButton.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        backButton.contentMode = .scaleAspectFit
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        termsOfUseView.layer.borderColor = UIColor.white.cgColor
        termsOfUseView.layer.borderWidth = 1
        
        privacyPolicyView.layer.borderColor = UIColor.white.cgColor
        privacyPolicyView.layer.borderWidth = 1
        
        iconTermsImageView.image = UIImage(named: "roundedTerms")
        iconTermsImageView.contentMode = .scaleAspectFit
        
        termsNextArrowImageView.tintColor = UIColor(resource: .Color.textColorTitel)
        termsNextArrowImageView.image = UIImage(systemName: "chevron.forward")
        termsNextArrowImageView.contentMode = .scaleAspectFit
        
        termsLabel.textAlignment = .left
        termsLabel.font = UIFont.manrope(ofSize: 15, style: .light)
        termsLabel.text = NSLocalizedString("App.Settings.ItemTermsOfUse", comment: "")
        
        iconPrivacyImageView.image = UIImage(named: "roundedPrivacy")
        iconPrivacyImageView.contentMode = .scaleAspectFit
        
        privacyNextArrowImageView.tintColor = UIColor(resource: .Color.textColorTitel)
        privacyNextArrowImageView.image = UIImage(systemName: "chevron.forward")
        privacyNextArrowImageView.contentMode = .scaleAspectFit
        
        privacyLabel.textAlignment = .left
        privacyLabel.font = UIFont.manrope(ofSize: 15, style: .light)
        privacyLabel.text = NSLocalizedString("App.Settings.ItemPrivacyPolicy", comment: "")
        
        termsOfUseButton.backgroundColor = UIColor(resource: .Color.backgroundColorView)
        termsOfUseButton.addTarget(self, action: #selector(termsOfUseButtonTapped), for: .touchUpInside)
        
        privacyPolicyButton.backgroundColor = UIColor(resource: .Color.backgroundColorView)
        privacyPolicyButton.addTarget(self, action: #selector(privacyPolicyButtonTapped), for: .touchUpInside)
    }
    
    private func setCornerRadius() {
        termsOfUseView.layer.cornerRadius = termsOfUseView.frame.height / 2
        termsOfUseView.clipsToBounds = true
        privacyPolicyView.layer.cornerRadius = privacyPolicyView.frame.height / 2
        privacyPolicyView.clipsToBounds = true
        iconTermsImageView.layer.cornerRadius = iconTermsImageView.frame.height / 2
        iconTermsImageView.clipsToBounds = true
        iconPrivacyImageView.layer.cornerRadius = iconPrivacyImageView.frame.height / 2
        iconPrivacyImageView.clipsToBounds = true
        backButton.layer.cornerRadius = termsOfUseView.frame.height / 2
        backButton.clipsToBounds = true
    }
    
    //MARK: - Actions
    
    @objc private func termsOfUseButtonTapped() {
        print("Terms of Use")
    }
    
    @objc private func privacyPolicyButtonTapped() {
        print("Privacy policy")
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Bindings
    
    private func bindings() {
        
    }
}
