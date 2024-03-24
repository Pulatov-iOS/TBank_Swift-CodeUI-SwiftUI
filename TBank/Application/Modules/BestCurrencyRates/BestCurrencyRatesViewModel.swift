import Combine

final class BestCurrencyRatesViewModel {
    
    // MARK: - Public properties
    var showSettingsPage: (() -> Void)?
    let currencyRatesSubject = CurrentValueSubject<[CurrencyRateDTO], Never>([])
    
    // MARK: - Private properties
    private var networkManager: NetworkManagerCurrency
    private var coreDataManager: CoreDataManager
    private var cancellables = Set<AnyCancellable>()
    
    init(networkManager: NetworkManagerCurrency, coreDataManager: CoreDataManager) {
        self.networkManager = networkManager
        self.coreDataManager = coreDataManager
        
        loadCurrencyRates()
    }
    
    // MARK: - Methods
    func settingsButtonTapped() {
        showSettingsPage?()
    }
    
    func fetchCurrencyRates() {
        if !coreDataManager.isUpdateCurrencyRates() {
            networkManager.fetchCurrencyRates { currencyRates in
                if let currencyRates = currencyRates {
                    let _ = self.coreDataManager.updateBankBranchCurrencyRate(currencyRates)
                    let _ = self.coreDataManager.updateCurrencyRates(currencyRates)
                    self.currencyRatesSubject.send(currencyRates)
                }
            }
        }
    }
    
    private func loadCurrencyRates() {
        coreDataManager.currencyRatesSubject
            .sink { currencyRates in
                self.currencyRatesSubject.send(currencyRates)
            }
            .store(in: &cancellables)
        
       coreDataManager.loadCurrencyRates()
    }
}
