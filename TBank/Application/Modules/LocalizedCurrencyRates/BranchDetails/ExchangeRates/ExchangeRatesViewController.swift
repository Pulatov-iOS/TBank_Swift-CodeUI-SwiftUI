import UIKit

//MARK: - Final class ExchangeRatesViewController

final class ExchangeRatesView: UIViewController {
    
    
    //MARK: - Properties of class
    
    var viewModel: ExchangeRatesViewModelProtocol!
    
    private let tableView = UITableView()
    
    
    
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
}



//MARK: - Extention to get UITableView protocol's methods

extension ExchangeRatesView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ExchangeRatesTableViewCell", for: indexPath) as? ExchangeRatesTableViewCell else { return UITableViewCell() }
        
        cell.backgroundColor = .clear
        return cell
    }
    
    
    
}



//MARK: - Implemendation of AddNewInfoInterractorInputProtocol protocol for AddNewInfoInterractor class

