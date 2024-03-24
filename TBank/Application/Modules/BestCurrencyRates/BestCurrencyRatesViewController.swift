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
        startLoadingAnimation()
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
        fetchButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 26).isActive = true
        
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        settingsButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        settingsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -26).isActive = true

        lastUpdatedLabel.translatesAutoresizingMaskIntoConstraints = false
        lastUpdatedLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        lastUpdatedLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.topAnchor.constraint(equalTo: lastUpdatedLabel.bottomAnchor, constant: 10).isActive = true
        searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.centerYAnchor.constraint(equalTo: searchTextField.centerYAnchor).isActive = true
        deleteButton.trailingAnchor.constraint(equalTo: searchTextField.trailingAnchor, constant: -10).isActive = true

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 5).isActive = true
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
        view.backgroundColor = .white
        
        titleLabel.text = NSLocalizedString("App.BestCurrencyRates.NavigationItemTitle", comment: "")
        titleLabel.textColor = .black
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        
        fetchButton.tintColor = .black
        fetchButton.setImage(UIImage(systemName: "goforward"), for: .normal)
        let symbolConfigurationAdd = UIImage.SymbolConfiguration(pointSize: 25)
        fetchButton.setPreferredSymbolConfiguration(symbolConfigurationAdd, forImageIn: .normal)
        fetchButton.addTarget(self, action: #selector(fetchButtonTapped), for: .touchUpInside)
        
        settingsButton.tintColor = .black
        settingsButton.setImage(UIImage(systemName: "gearshape"), for: .normal)
        let symbolConfigurationSetup = UIImage.SymbolConfiguration(pointSize: 25)
        settingsButton.setPreferredSymbolConfiguration(symbolConfigurationSetup, forImageIn: .normal)
        settingsButton.addTarget(self, action: #selector(settingsButtonTapped), for: .touchUpInside)
        
        deleteButton.tintColor = .gray
        deleteButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        let symbolConfigurationDelete = UIImage.SymbolConfiguration(pointSize: 20)
        deleteButton.setPreferredSymbolConfiguration(symbolConfigurationDelete, forImageIn: .normal)
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        
        lastUpdatedLabel.textColor = .gray
        lastUpdatedLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        
        searchTextField.placeholder = NSLocalizedString("App.BestCurrencyRates.searchTextField", comment: "")
        searchTextField.borderStyle = .roundedRect
        searchTextField.addTarget(self, action: #selector(searchTextFieldDidChange(_:)), for: .editingChanged)
        
        backgroundTabBarView.backgroundColor = UIColor(resource: .Color.TabBar.background)
    }
    
    private func bind() {
        viewModel.currencyRatesSubject
            .sink { [weak self] _ in
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
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
    
    private func startLoadingAnimation() {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .black
        activityIndicator.center = view.center
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
    }
    
    private func stopLoadingAnimation() {
        for subview in view.subviews {
            if let activityIndicator = subview as? UIActivityIndicatorView {
                activityIndicator.stopAnimating()
                activityIndicator.removeFromSuperview()
                break
            }
        }
    }
    
//    private func filterCurrencyRates(with searchText: String) {
//        if searchText.isEmpty {
//            filteredCurrencyRates = currencyRates
//        } else {
//            filteredCurrencyRates = currencyRates.filter { $0.abbreviation.lowercased().contains(searchText.lowercased()) || $0.curName.lowercased().contains(searchText.lowercased())}
//        }
//        tableView.reloadData()
//    }
    
    @objc func fetchButtonTapped() {
        viewModel.fetchCurrencyRates()
    }
    
    @objc func deleteButtonTapped() {
        searchTextField.text = nil
//        filterCurrencyRates(with: "")
    }
    
    @objc func settingsButtonTapped() {
        viewModel.settingsButtonTapped()
    }

    @objc private func searchTextFieldDidChange(_ textField: UITextField) {
//        filterCurrencyRates(with: textField.text!)
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
