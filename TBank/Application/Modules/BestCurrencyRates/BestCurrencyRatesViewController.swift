import UIKit
import SnapKit
import Combine

final class BestCurrencyRatesViewController: UIViewController {
    
    // MARK: - Public Properties
    var viewModel: BestCurrencyRatesViewModel!
    
    // MARK: - UI Properties
    private let tabBar: TabBarItem
    private let titleLabel = UILabel()
    private let fetchButton = UIButton()
    private let tableView = UITableView()
    private let lastUpdatedLabel = UILabel()
    private let searchTextField = UITextField()
    private let deleteButton = UIButton()
    private let backgroundTabBarView = UIView()
    private let settingsButton = UIButton()
    private var isSearching: Bool {
        return !searchTextField.text!.isEmpty
    }
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - LyfeCycle
    init(tabBar: TabBarItem) {
        self.tabBar = tabBar
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hidesBottomBarWhenPushed = true
        view.addSubview(tabBar)
        addSubviews()
        configureConstraints()
        configureUI()
        bind()
        setupTableView()
    }
    
    // MARK: - Methods
    private func addSubviews() {
        view.addSubview(titleLabel)
        view.addSubview(fetchButton)
        view.addSubview(tableView)
        view.addSubview(lastUpdatedLabel)
        view.addSubview(searchTextField)
        view.addSubview(deleteButton)
        view.addSubview(backgroundTabBarView)
        view.addSubview(tabBar)
        view.addSubview(settingsButton)
    }
    
    private func configureConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 80).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        fetchButton.translatesAutoresizingMaskIntoConstraints = false
        fetchButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        fetchButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24).isActive = true
        fetchButton.heightAnchor.constraint(equalToConstant: 55).isActive = true
        fetchButton.widthAnchor.constraint(equalToConstant: 55).isActive = true
        
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        settingsButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        settingsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24).isActive = true
        settingsButton.heightAnchor.constraint(equalToConstant: 55).isActive = true
        settingsButton.widthAnchor.constraint(equalToConstant: 55).isActive = true
        
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 33).isActive = true
        searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24).isActive = true
        searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24).isActive = true
        searchTextField.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        lastUpdatedLabel.translatesAutoresizingMaskIntoConstraints = false
        lastUpdatedLabel.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 10).isActive = true
        lastUpdatedLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.centerYAnchor.constraint(equalTo: searchTextField.centerYAnchor).isActive = true
        deleteButton.trailingAnchor.constraint(equalTo: searchTextField.trailingAnchor, constant: -6).isActive = true
        deleteButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        deleteButton.widthAnchor.constraint(equalToConstant: 35).isActive = true

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: lastUpdatedLabel.bottomAnchor, constant: 5).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
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
        
        titleLabel.text = NSLocalizedString("App.BestCurrencyRates.NavigationItemTitle", comment: "")
        titleLabel.textColor = UIColor(resource: .Color.textColorTitel)
        titleLabel.font = UIFont.manrope(ofSize: 24, style: .bold)
        
        fetchButton.tintColor = UIColor(resource: .Color.textColorTitel)
        fetchButton.setImage(UIImage(systemName: "goforward"), for: .normal)
        let symbolConfigurationAdd = UIImage.SymbolConfiguration(pointSize: 28)
        fetchButton.setPreferredSymbolConfiguration(symbolConfigurationAdd, forImageIn: .normal)
        fetchButton.addTarget(self, action: #selector(fetchButtonTapped), for: .touchUpInside)
        fetchButton.backgroundColor = UIColor(resource: .Color.backgroundColorItem)
        fetchButton.layer.cornerRadius = 27.5
        
        settingsButton.tintColor = UIColor(resource: .Color.textColorTitel)
        settingsButton.setImage(UIImage(systemName: "gearshape"), for: .normal)
        let symbolConfigurationSetup = UIImage.SymbolConfiguration(pointSize: 28)
        settingsButton.setPreferredSymbolConfiguration(symbolConfigurationSetup, forImageIn: .normal)
        settingsButton.addTarget(self, action: #selector(settingsButtonTapped), for: .touchUpInside)
        settingsButton.backgroundColor = UIColor(resource: .Color.backgroundColorItem)
        settingsButton.layer.cornerRadius = 27.5

        deleteButton.tintColor = .gray
        deleteButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        let symbolConfigurationDelete = UIImage.SymbolConfiguration(pointSize: 18)
        deleteButton.setPreferredSymbolConfiguration(symbolConfigurationDelete, forImageIn: .normal)
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        deleteButton.backgroundColor = UIColor(resource: .Color.backgroundColorItem)
        deleteButton.layer.cornerRadius = 17.5
        
        lastUpdatedLabel.textColor = .gray
        lastUpdatedLabel.font = UIFont.manrope(ofSize: 13, style: .light)
        
        searchTextField.placeholder = NSLocalizedString("App.BestCurrencyRates.searchTextField", comment: "")
        searchTextField.layer.cornerRadius = 22.5
        searchTextField.layer.masksToBounds = true
        searchTextField.backgroundColor = UIColor(resource: .Color.backgroundColorItem)
        searchTextField.addTarget(self, action: #selector(searchTextFieldDidChange(_:)), for: .editingChanged)
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: searchTextField.frame.height))
        searchTextField.leftView = paddingView
        searchTextField.leftViewMode = .always

        backgroundTabBarView.backgroundColor = UIColor(resource: .Color.backgroundColorView)
    }
    
    private func bind() {
        viewModel.currencyRatesSubject
            .sink { [weak self] _ in
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                self?.lastUpdatedLabel.text = NSLocalizedString("App.BestCurrencyRates.lastUpdatedLabel", comment: "") + "\(dateFormatter.string(from: Date()))"
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(BestCurrencyRatesTableViewCell.self, forCellReuseIdentifier: "BestCurrencyRatesTableViewCell")
        tableView.rowHeight = 100
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
    }
    
    private func filterCurrencyRates(with searchText: String) {
        if searchText.isEmpty {
            viewModel.loadCurrencyRates()
        } else {
            let filteredRates = viewModel.currencyRatesSubject.value.filter { $0.abbreviation.lowercased().contains(searchText.lowercased()) || $0.curName.lowercased().contains(searchText.lowercased()) }
            viewModel.currencyRatesSubject.send(filteredRates)
        }
        tableView.reloadData()
    }

    @objc func fetchButtonTapped() {
        viewModel.loadCurrencyRates()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let alertController = UIAlertController(title: NSLocalizedString("App.BestCurrencyRates.alertController.titel", comment: ""), message: NSLocalizedString("App.BestCurrencyRates.alertController.message", comment: "") + "\(dateFormatter.string(from: Date()))", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func deleteButtonTapped() {
        searchTextField.text = nil
        filterCurrencyRates(with: "")
    }
    
    @objc func settingsButtonTapped() {
        viewModel.settingsButtonTapped()
    }

    @objc private func searchTextFieldDidChange(_ textField: UITextField) {
        filterCurrencyRates(with: textField.text ?? "")
    }
}

//MARK: - Table Delegate/DataSource
extension BestCurrencyRatesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.currencyRatesSubject.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BestCurrencyRatesTableViewCell", for: indexPath) as? BestCurrencyRatesTableViewCell else {
            return UITableViewCell()
        }
        
        let rate = viewModel.currencyRatesSubject.value[indexPath.row]
        cell.setInformation(with: rate)
        return cell
    }
}
