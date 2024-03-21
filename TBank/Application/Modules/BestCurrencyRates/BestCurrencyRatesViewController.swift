import UIKit
import SnapKit

final class BestCurrencyRatesViewController: UIViewController {
    
    // MARK: - Public Properties
    var viewModel: BestCurrencyRatesViewModel!
    
    private let titleLabel = UILabel()
    private let addButton = UIButton()
    private let tableView = UITableView()
    private var currencyRates: [CurrencyRate] = []
    private let lastUpdatedLabel = UILabel()
    private let searchTextField = UITextField()
    
    private var filteredCurrencyRates: [CurrencyRate] = []
    private var isSearching: Bool {
        return !searchTextField.text!.isEmpty
    }
    
    
    // MARK: - LyfeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addSubviews()
        configureConstraints()
        configureUI()
        bindings()
        setupTableView()
        fetchExchangeRates()
        startLoadingAnimation()
    }
    
    // MARK: - Methods
    private func addSubviews() {
        view.addSubview(titleLabel)
        view.addSubview(addButton)
        view.addSubview(tableView)
        view.addSubview(lastUpdatedLabel)
        view.addSubview(searchTextField)
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(BestCurrencyRatesTableViewCell.self, forCellReuseIdentifier: "BestCurrencyRatesTableViewCell")
        tableView.rowHeight = 100
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
    }
    
    private func fetchExchangeRates() {
        NetworkManagerCurrency.shared.fetchExchangeRates { [weak self] rates in
            if let rates = rates {
 
                let filteredRates = rates.filter {
                    $0.abbreviation == "USD" ||
                    $0.abbreviation == "EUR" ||
                    $0.abbreviation == "RUB" ||
                    $0.abbreviation == "PLN" ||
                    $0.abbreviation == "CNY"
                }
                DispatchQueue.main.async {
                    self?.currencyRates = rates//filteredRates
                    self?.tableView.reloadData()
                    
                    // Обновляем текст метки с временем последней загрузки
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    self?.lastUpdatedLabel.text = "Last updated: \(dateFormatter.string(from: Date())) NBRB.BY"
                    
                    self?.stopLoadingAnimation()
                }
            } else {
                print("Failed to fetch exchange rates")
            }
        }
    }
    
    private func configureConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 80).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -26).isActive = true
        
        lastUpdatedLabel.translatesAutoresizingMaskIntoConstraints = false
        lastUpdatedLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        lastUpdatedLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.topAnchor.constraint(equalTo: lastUpdatedLabel.bottomAnchor, constant: 10).isActive = true
        searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 5).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    private func configureUI() {
        //navigationItem.title = NSLocalizedString("App.BestCurrencyRates.NavigationItemTitle", comment: "")
        
        titleLabel.text = NSLocalizedString("App.BestCurrencyRates.NavigationItemTitle", comment: "")
        titleLabel.textColor = .black
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        
        addButton.tintColor = .black
        addButton.setImage(UIImage(systemName: "goforward"), for: .normal)
        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 25)
        addButton.setPreferredSymbolConfiguration(symbolConfiguration, forImageIn: .normal)
        addButton.addTarget(self, action: #selector(tapOnAddButton), for: .touchUpInside)
        
        lastUpdatedLabel.textColor = .gray
        lastUpdatedLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        
        searchTextField.placeholder = "Search Currency"
        searchTextField.borderStyle = .roundedRect
        searchTextField.addTarget(self, action: #selector(searchTextFieldDidChange(_:)), for: .editingChanged)
    }
    
    
    private func startLoadingAnimation() {
        // Создаем и добавляем индикатор загрузки на вашу вью
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .black
        activityIndicator.center = view.center
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
    }
    
    private func stopLoadingAnimation() {
        // Удаляем индикатор загрузки из вашей вью
        for subview in view.subviews {
            if let activityIndicator = subview as? UIActivityIndicatorView {
                activityIndicator.stopAnimating()
                activityIndicator.removeFromSuperview()
                break
            }
        }
    }
    
    private func filterCurrencyRates(with searchText: String) {
        if searchText.isEmpty {
            filteredCurrencyRates = currencyRates
        } else {
            filteredCurrencyRates = currencyRates.filter { $0.abbreviation.lowercased().contains(searchText.lowercased()) }
        }
        tableView.reloadData()
    }
    
    @objc func tapOnAddButton() {
        fetchExchangeRates()
        startLoadingAnimation()
        print("update")
    }
    
    @objc private func searchTextFieldDidChange(_ textField: UITextField) {
        filterCurrencyRates(with: textField.text!)
    }
    
    private func bindings() {
        
    }
    
}
extension BestCurrencyRatesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? filteredCurrencyRates.count : currencyRates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BestCurrencyRatesTableViewCell", for: indexPath) as? BestCurrencyRatesTableViewCell else {
            return UITableViewCell()
        }
        
        let rate = isSearching ? filteredCurrencyRates[indexPath.row] : currencyRates[indexPath.row]
        cell.configure(with: rate)
        return cell
    }
}
