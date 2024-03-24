import UIKit
import SnapKit
import Combine

final class LocalizedCurrencyRatesViewController: UIViewController {
    
    // MARK: - Public Properties
    var viewModel: LocalizedCurrencyRatesViewModel!
    
    // MARK: - UI Properties
    private let titleLabel = UILabel()
    private let settingsButton = UIButton()
    private let сurrencyButton = UIButton()
    private let tableView = UITableView()
    private let tabBar: TabBarItem
    private let backgroundTabBarView = UIView()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    init(tabBar: TabBarItem) {
        self.tabBar = tabBar
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LyfeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        addSubviews()
        configureConstraints()
        configureUI()
        bind()
        configureTableView()
    }
    
    // MARK: - Methods
    private func addSubviews() {
        view.addSubview(titleLabel)
        view.addSubview(settingsButton)
        view.addSubview(сurrencyButton)
        view.addSubview(tableView)
        view.addSubview(backgroundTabBarView)
        view.addSubview(tabBar)
    }
    
    private func configureConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 80).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        settingsButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        settingsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24).isActive = true
        settingsButton.heightAnchor.constraint(equalToConstant: 55).isActive = true
        settingsButton.widthAnchor.constraint(equalToConstant: 55).isActive = true

        сurrencyButton.translatesAutoresizingMaskIntoConstraints = false
        сurrencyButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        сurrencyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24).isActive = true
        сurrencyButton.heightAnchor.constraint(equalToConstant: 55).isActive = true
        сurrencyButton.widthAnchor.constraint(equalToConstant: 55).isActive = true
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 44).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        tabBar.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(30)
            make.width.equalToSuperview()
        }
        
        backgroundTabBarView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-10)
        }
    }
    
    private func configureUI() {
        view.backgroundColor = UIColor(resource: .Color.backgroundColorView)
        tableView.showsVerticalScrollIndicator = false
        
        titleLabel.text = NSLocalizedString("App.LocalizedCurrencyRates.NavigationItemTitle", comment: "")
        titleLabel.textColor = UIColor(resource: .Color.textColorTitel)
        titleLabel.font = UIFont.manrope(ofSize: 24, style: .bold)
        
        settingsButton.tintColor = UIColor(resource: .Color.textColorTitel)
        settingsButton.setImage(UIImage(systemName: "gearshape"), for: .normal)
        let symbolConfigurationSetup = UIImage.SymbolConfiguration(pointSize: 28)
        settingsButton.setPreferredSymbolConfiguration(symbolConfigurationSetup, forImageIn: .normal)
        settingsButton.addTarget(self, action: #selector(settingsButtonTapped), for: .touchUpInside)
        settingsButton.backgroundColor = UIColor(resource: .Color.backgroundColorItem)
        settingsButton.layer.cornerRadius = 27.5
        
        сurrencyButton.tintColor = UIColor(resource: .Color.textColorTitel)
        сurrencyButton.setTitle("USD", for: .normal)
        сurrencyButton.setTitleColor(UIColor(resource: .Color.textColorTitel), for: .normal)
        сurrencyButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        сurrencyButton.addTarget(self, action: #selector(currencyButtonTapped), for: .touchUpInside)
        сurrencyButton.backgroundColor = UIColor(resource: .Color.backgroundColorItem)
        сurrencyButton.layer.cornerRadius = 27.5
        
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.rowHeight = 100
        
        backgroundTabBarView.backgroundColor = UIColor(resource: .Color.TabBar.background)
    }
    
    private func bind() {
        viewModel.bankBranchesSubject
            .sink(receiveValue: { [weak self] data in
                self?.tableView.reloadData()
            })
            .store(in: &cancellables)
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(LocalizedCurrencyRatesTableViewCell.self, forCellReuseIdentifier: "LocalizedCurrencyRatesTableViewCell")
    }
    
    private func showCurrencySelectionActionSheet() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        for currencyRate in viewModel.currencyRatesSubject.value {
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
    
    private func handleCurrencySelection(_ currencyRate: CurrencyRateDTO) {
        сurrencyButton.setTitle(currencyRate.abbreviation, for: .normal)
    }
        
    private func reloadCurrencyButton() {
        if let currencyRate = viewModel.currencyRatesSubject.value.first {
            сurrencyButton.setTitle(currencyRate.abbreviation, for: .normal)
        }
    }
    
    @objc func settingsButtonTapped() {
        viewModel.settingsButtonTapped()
    }
    
    @objc func currencyButtonTapped() {
        showCurrencySelectionActionSheet()
    }
}

//MARK: - Table Delegate/DataSource
extension LocalizedCurrencyRatesViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.bankBranchesSubject.value.count + 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < viewModel.bankBranchesSubject.value.count {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "LocalizedCurrencyRatesTableViewCell", for: indexPath) as? LocalizedCurrencyRatesTableViewCell else {
                return UITableViewCell()
            }
            
            cell.backgroundColor = .clear
            cell.setInformation(bankBranchesSubject: viewModel.bankBranchesSubject.value[indexPath.row], rate: viewModel.getCurrencyRate(idBankBranch: Int(viewModel.bankBranchesSubject.value[indexPath.row].id)))
            return cell
        } else {
            let emptyCell = UITableViewCell()
            emptyCell.backgroundColor = UIColor(resource: .Color.backgroundColorView)
            return emptyCell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < viewModel.bankBranchesSubject.value.count {
            let bankBranche = viewModel.bankBranchesSubject.value[indexPath.row]
            viewModel.tableCellTapped(bankBranche)
        } else {
        }
    }

}
