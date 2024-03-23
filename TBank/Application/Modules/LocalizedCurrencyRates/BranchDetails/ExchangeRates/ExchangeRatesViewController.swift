import UIKit
import Combine

//MARK: - Final class ExchangeRatesViewController

final class ExchangeRatesView: UIViewController {
    
    
    //MARK: - Properties of class
    
    var viewModel: ExchangeRatesViewModelProtocol!
    
    private let tableView = UITableView()
    private var cancellables = Set<AnyCancellable>()
    private var currencies: [Currencies] = []
    
    
    //MARK: - Lifecycle of controller
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        testPP()
        
        addSubviews()
        setConstraintes()
        configureUI()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureNavBar()
        getCurrensiesBinding()
        viewModel.loadData()
    }
    
    
    
//MARK: - Configurations of Navigation bar
    
    private func configureNavBar() {
        self.title = "Exchange Rates"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black, .font: UIFont.systemFont(ofSize: 21, weight: .bold)]
        let mapButton = UIBarButtonItem(image: UIImage(named: "map"), style: .done, target: nil, action: #selector(mapButtonTapped))
        mapButton.tintColor = .lightGray
        navigationItem.rightBarButtonItem = mapButton
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
        
        view.backgroundColor = .backgroundGray
        
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
        viewModel.loadCurrencyPublisher
            .sink { [weak self] data in
                self?.currencies = data
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    
    
//MARK: - Actions
    
    @objc private func mapButtonTapped() {
        
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
}



extension ExchangeRatesView {
    
    func testPP() {
        let usd = TestCurrency(name: "USD", rate: 3.24, avr: 3.25, dynamic: -0.01)
        let eur = TestCurrency(name: "EUR", rate: 3.54, avr: 3.53, dynamic: -0.01)
        let rur = TestCurrency(name: "RUR", rate: 3.1, avr: 3.0, dynamic: 0.1)
        
        var currancyArray = [TestCurrency]()
        currancyArray.append(usd)
        currancyArray.append(eur)
        currancyArray.append(rur)
        
        currancyArray.forEach { currancy in
            let result = CoreDataManager.instance.saveCurrency(name: currancy.name, rate: currancy.rate, avr: currancy.avr, dynamic: currancy.dynamic)
            switch result {
            case .success(_):
                print("save \(currancy.name)")
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
}

struct TestCurrency {
    let name: String
    let rate: Double
    let avr: Double
    let dynamic: Double
}
