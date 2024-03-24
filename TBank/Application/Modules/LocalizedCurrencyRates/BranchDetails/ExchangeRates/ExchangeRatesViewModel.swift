import Combine

final class ExchangeRatesViewModel {
    
    //MARK: - Public Properties
    let currencyRatesSubject = CurrentValueSubject<[CurrencyRateDTO], Never>([])
    
    // MARK: - Private properties
    private var coreDataManager: CoreDataManager
    private var cancellables = Set<AnyCancellable>()
    
    init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
    }
    
    func loadCurrencyRates() {
        coreDataManager.currencyRatesSubject
            .sink { currencyRates in
                self.currencyRatesSubject.send(currencyRates)
            }
            .store(in: &cancellables)
        
        coreDataManager.loadCurrencyRates()
    }
}
