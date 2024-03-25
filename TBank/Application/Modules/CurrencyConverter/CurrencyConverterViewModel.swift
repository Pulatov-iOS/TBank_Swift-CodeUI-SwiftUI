import Combine

final class CurrencyConverterViewModel {
    let amountForChangeSubject = PassthroughSubject<Double, Never>()
    let currentCurrencySubject = CurrentValueSubject<[CurrencyRateDTO], Never>([])
    let desiredCurrencySubject = CurrentValueSubject<[CurrencyRateDTO], Never>([])
    
    private var coreDataManager: CoreDataManager
    private var cancellables = Set<AnyCancellable>()
    
    init(coreDataManager: CoreDataManager, cancellables: Set<AnyCancellable> = Set<AnyCancellable>()) {
        self.coreDataManager = coreDataManager
        self.cancellables = cancellables
        
        bind()
    }
    
    func changeTextField(enteredAmount: String) {
        calculateCurrencyExchange(amountForCalculate: enteredAmount, currencyRate: 3.33)
    }
    
    func changeCurrencyButtonTapped() {
        
    }
    
    func calculateCurrencyExchange(amountForCalculate: String, currencyRate: Double) {
        let result = (Double(amountForCalculate) ?? 0) * currencyRate
        
        amountForChangeSubject.send(result)
    }
    
    private func update() {
        self.coreDataManager.loadCurrencyRates()
    }
    
    private func bind() {
        coreDataManager.currencyRatesSubject
            .sink { currentCurrency in
            self.currentCurrencySubject.send(currentCurrency)
        }
        .store(in: &cancellables)
        
        coreDataManager.currencyRatesSubject
            .sink { desiredCurrency in
            self.desiredCurrencySubject.send(desiredCurrency)
        }
        .store(in: &cancellables)
    }
    
}

