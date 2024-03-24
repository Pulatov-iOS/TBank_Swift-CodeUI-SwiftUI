import UIKit
import Combine

final class ExchangeRatesView: UIViewController {
    
    //MARK: - Public Properties
    var viewModel: ExchangeRatesViewModel!
    
    //MARK: - UI Properties
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
        
        configureNavBar()
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
    
    private func bind() {
        viewModel.currencyRatesSubject
            .sink { [weak self] data in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
}

//MARK: - Table Delegate/DataSource
extension ExchangeRatesView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.currencyRatesSubject.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currencyRate = viewModel.currencyRatesSubject.value[indexPath.row]

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ExchangeRatesTableViewCell", for: indexPath) as? ExchangeRatesTableViewCell else { return UITableViewCell() }
        
        cell.backgroundColor = .clear
        cell.setExchangeRate(exchangeRate: currencyRate)
        return cell
    }
}
