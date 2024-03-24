import UIKit
import Combine

final class ExchangeRatesViewController: UIViewController {
    
    //MARK: - Public Properties
    var viewModel: ExchangeRatesViewModel!
    
    //MARK: - UI Properties
    private let titleLabel = UILabel()
    private let mapButton = UIButton()
    private let tableView = UITableView()
    private var cancellables = Set<AnyCancellable>()
          
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
        setConstraintes()
        configureUI()
        bind()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    //MARK: - Adding of subViews
    private func addSubviews() {
        view.addSubviews(with: titleLabel, mapButton, tableView)
    }
    
    //MARK: - Setting of constraintes
    private func setConstraintes() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        mapButton.translatesAutoresizingMaskIntoConstraints = false
        mapButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        mapButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -26).isActive = true
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: mapButton.bottomAnchor, constant: 10).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    //MARK: - Configuration of User Interface
    private func configureUI() {
        view.backgroundColor = UIColor(resource: .Color.backgroundColorView)
        
        titleLabel.text = "Exchange Rates"
        titleLabel.textColor = .black
        titleLabel.font = UIFont.manrope(ofSize: 24, style: .bold)
        
        mapButton.tintColor = .black
        mapButton.setImage(UIImage(named: "map"), for: .normal)
        mapButton.contentMode = .scaleAspectFit
        mapButton.addTarget(self, action: #selector(mapButtonTapped), for: .touchUpInside)
        
        tableView.backgroundColor = UIColor(resource: .Color.backgroundColorView)
        tableView.separatorStyle = .none
        tableView.rowHeight = 100
    }
    
    //MARK: - TableView configuration
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ExchangeRatesTableViewCell.self, forCellReuseIdentifier: "ExchangeRatesTableViewCell")
    }
    
    private func bind() {
//        viewModel.currencyRatesSubject
//            .sink { [weak self] data in
//                self?.tableView.reloadData()
//            }
//            .store(in: &cancellables)
    }
    
    //MARK: - Actions
    @objc func mapButtonTapped() {
        viewModel.mapButtonTapped()
    }
}

//MARK: - Table Delegate/DataSource
extension ExchangeRatesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 5
//        return viewModel.currencyRatesSubject.value.count
        return viewModel.currencyRates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let currencyRate = CurrencyRateDTO(abbreviation: "USD", curName: "", rate: 2.23, lastRate: 2.21, scale: 2)
//        viewModel.currencyRatesSubject.value[indexPath.row]
        let currencyRate = viewModel.currencyRates[indexPath.row]

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ExchangeRatesTableViewCell", for: indexPath) as? ExchangeRatesTableViewCell else { return UITableViewCell() }
        
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
//        let rate = viewModel.currencyRatesSubject.value[indexPath.row]
        cell.setInformation(with: currencyRate)
        return cell
    }
}
