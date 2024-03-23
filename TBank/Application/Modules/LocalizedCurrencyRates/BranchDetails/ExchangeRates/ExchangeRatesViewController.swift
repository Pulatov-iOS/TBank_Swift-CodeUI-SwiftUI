import UIKit

//MARK: - Final class ExchangeRatesViewController

final class ExchangeRatesView: UIViewController {
    
    
    //MARK: - Properties of class
    
    var viewModel: ExchangeRatesViewModelProtocol!
    
    private let tableView = UITableView()
    private var currencies: [Currencies] = []
    
    
    //MARK: - Lifecycle of controller
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
        setConstraintes()
        configureUI()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureNavBar()
        viewModel.loadData()
    }
    
    
    
    //MARK: - Configurations of Navigation bar
    
    private func configureNavBar() {
        self.title = "Exchange Rates"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black, .font: UIFont.systemFont(ofSize: 21, weight: .bold)]
    }
    
    
    
//MARK: - Adding of subViews
    
    private func addSubviews() {
        view.addSubviews(with: tableView)
    }
    
    
    
    //MARK: - Setting of constraintes
    
    private func setConstraintes() {
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    
    
    //MARK: - Configuration of User Interface
    
    private func configureUI() {
        
        view.backgroundColor = .white
        
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.rowHeight = 100
    }
    
    
    
//MARK: - TableView configuration
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ExchangeRatesTableViewCell.self, forCellReuseIdentifier: "ExchangeRatesTableViewCell")
    }
    
    
    
//MARK: - Baindings
    
    private func getCurrensiesBinding() {
        viewModel.loadedCurrentCurrencies = { [weak self] data in
            self?.currencies = data
            self?.tableView.reloadData()
        }
    }
}



//MARK: - Extention to get UITableView protocol's methods

extension ExchangeRatesView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencies.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currency = currencies[indexPath.row]
        let name = currency.name ?? "No name"
        let rate = currency.rate
        let avr = currency.avr
        let dynamic = currency.dynamic
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ExchangeRatesTableViewCell", for: indexPath) as? ExchangeRatesTableViewCell else { return UITableViewCell() }
        
        cell.backgroundColor = .clear
        cell.getData(with: name, rate, avr, dynamic)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationController?.pushViewController(SettingsViewController(), animated: true)
    }
}
