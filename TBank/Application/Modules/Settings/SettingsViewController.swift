import UIKit
import SnapKit

//MARK: - Final class SettingsViewController

final class SettingsViewController: UIViewController {
    
    
    // MARK: - Public Properties
    var viewModel: SettingsViewModel!

    private let titleLabel = UILabel()
    private let backButton = UIButton()

    let termsOfUseView = UIView()
    let privacyPolicyView = UIView()
    let iconTermsImageView = UIImageView()
    let iconPrivacyImageView = UIImageView()
    let termsLabel = UILabel()
    let privacyLabel = UILabel()
    let termsNextArrowImageView = UIImageView()
    let privacyNextArrowImageView = UIImageView()
    let termsOfUseButton = UIButton()
    let privacyPolicyButton = UIButton()
    
    
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureNavBar()
    }
    
    
    
//MARK: - Configurations of Navigation bar
    
    private func configureNavBar() {
        self.title = "Settings"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black, .font: UIFont.systemFont(ofSize: 21, weight: .bold)]
    }
    
    
    
    // MARK: - Add subviews
    
    private func addSubviews() {
        view.addSubviews(with: titleLabel, backButton, termsOfUseView, privacyPolicyView)
        termsOfUseView.addSubviews(with: termsLabel, termsNextArrowImageView, iconTermsImageView, termsOfUseButton)
        privacyPolicyView.addSubviews(with: privacyLabel, privacyNextArrowImageView, iconPrivacyImageView, privacyPolicyButton)
    }
    
    
    
    //MARK: - Configure constraintes
    
    private func configureConstraints() {
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 80).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 26).isActive = true
        
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
        view.backgroundColor = UIColor.white
        
        titleLabel.text = "Settings"
        titleLabel.textColor = .black
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        
        backButton.tintColor = .black
        backButton.setImage(UIImage(named: "roundedBack"), for: .normal)
        backButton.contentMode = .scaleAspectFit
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        termsOfUseView.layer.borderColor = UIColor.white.cgColor
        termsOfUseView.layer.borderWidth = 1
        
        privacyPolicyView.layer.borderColor = UIColor.white.cgColor
        privacyPolicyView.layer.borderWidth = 1
        
        iconTermsImageView.image = UIImage(named: "roundedTerms")
        iconTermsImageView.contentMode = .scaleAspectFit
        
        termsNextArrowImageView.image = UIImage(named: "followArrow")
        termsNextArrowImageView.contentMode = .scaleAspectFit
        
        termsLabel.textAlignment = .left
        termsLabel.font = UIFont.manrope(ofSize: 20, style: .light)
        termsLabel.text = "Terms of Use"
        
        iconPrivacyImageView.image = UIImage(named: "roundedPrivacy")
        iconPrivacyImageView.contentMode = .scaleAspectFit
        
        privacyNextArrowImageView.image = UIImage(named: "followArrow")
        privacyNextArrowImageView.contentMode = .scaleAspectFit
        
        privacyLabel.textAlignment = .left
        privacyLabel.font = UIFont.manrope(ofSize: 20, style: .light)
        privacyLabel.text = "Privacy policy"
        
        termsOfUseButton.backgroundColor = .clear
        termsOfUseButton.addTarget(self, action: #selector(termsOfUseButtonTapped), for: .touchUpInside)
        
        privacyPolicyButton.backgroundColor = .clear
        privacyPolicyButton.addTarget(self, action: #selector(privacyPolicyButtonTapped), for: .touchUpInside)
    }
    
    private func setCornerRadius() {
        termsOfUseView.layer.cornerRadius = termsOfUseView.frame.height / 2
        termsOfUseView.clipsToBounds = true
        privacyPolicyView.layer.cornerRadius = privacyPolicyView.frame.height / 2
        iconTermsImageView.layer.cornerRadius = iconTermsImageView.frame.height / 2
        iconPrivacyImageView.layer.cornerRadius = iconPrivacyImageView.frame.height / 2
    }
    
    
    
    //MARK: - Actions
    
    @objc private func termsOfUseButtonTapped() {
        
    }
    
    @objc private func privacyPolicyButtonTapped() {
        
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    
    
    //MARK: - Bindings
    
    private func bindings() {
        
    }
}
