import UIKit
import Combine

final class ExchangeRatesViewController: UIViewController {
    
    //MARK: - Public Properties
    var viewModel: ExchangeRatesViewModel!
    
    //MARK: - UI Properties
    private let titleLabel = UILabel()
    private let numberOfBankBranchLabel = UILabel()
    private let mapButton = UIButton()
    private let tableView = UITableView()
    private var cancellables = Set<AnyCancellable>()
          
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
        setConstraintes()
        configureUI()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    //MARK: - Adding of subViews
    private func addSubviews() {
        view.addSubviews(with: titleLabel, mapButton, numberOfBankBranchLabel, tableView)
    }
    
    //MARK: - Setting of constraintes
    private func setConstraintes() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        mapButton.translatesAutoresizingMaskIntoConstraints = false
        mapButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        mapButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -26).isActive = true
        
        numberOfBankBranchLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: numberOfBankBranchLabel.bottomAnchor, constant: 10).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    //MARK: - Configuration of User Interface
    private func configureUI() {
        view.backgroundColor = UIColor(resource: .Color.backgroundColorView)
        titleLabel.text = NSLocalizedString("App.LocalizedCurrencyRates.BranchDetails.ExchangeRates.NavigationItemTitle", comment: "")
        titleLabel.textColor = UIColor(resource: .Color.LocalizedCurrencyRates.BranchDetails.ExchangeRates.textTitle)
        titleLabel.font = UIFont.manrope(ofSize: 24, style: .bold)
        
        numberOfBankBranchLabel.text = "\(NSLocalizedString("App.LocalizedCurrencyRates.BranchDetails.ExchangeRates.SecondNavigationItemTitle", comment: "")) \(String(describing: viewModel.bankBranch.branchNumber!))"
        numberOfBankBranchLabel.font = UIFont.manrope(ofSize: 15, style: .bold)
        numberOfBankBranchLabel.textColor = UIColor(resource: .Color.LocalizedCurrencyRates.BranchDetails.ExchangeRates.secondTextTitle)
        
        mapButton.tintColor = .black
        mapButton.setImage(UIImage(named: "map"), for: .normal)
        mapButton.contentMode = .scaleAspectFit
        mapButton.addTarget(self, action: #selector(mapButtonTapped), for: .touchUpInside)
        
        tableView.backgroundColor = UIColor(resource: .Color.backgroundColorView)
        tableView.separatorStyle = .none
        tableView.rowHeight = 100
        tableView.showsVerticalScrollIndicator = false
    }
    
    //MARK: - TableView configuration
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ExchangeRatesTableViewCell.self, forCellReuseIdentifier: "ExchangeRatesTableViewCell")
    }
    
    //MARK: - Actions
    @objc func mapButtonTapped() {
        viewModel.mapButtonTapped()
    }
}

//MARK: - Table Delegate/DataSource
extension ExchangeRatesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.currencyRates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currencyRate = viewModel.currencyRates[indexPath.row]

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ExchangeRatesTableViewCell", for: indexPath) as? ExchangeRatesTableViewCell else { return UITableViewCell() }
        
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        cell.setInformation(with: currencyRate)
        return cell
    }
}
