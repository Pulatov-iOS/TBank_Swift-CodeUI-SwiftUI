import Combine

final class CurrencyConverterViewModel {
    
    // MARK: - Public Properties
    let amountForChangeSubject = PassthroughSubject<Double, Never>()
    let changingCurrenciesSubject = PassthroughSubject<Bool, Never>()
    let currentCurrencySubject = CurrentValueSubject<[CurrencyRateDTO], Never>([])
    let desiredCurrencySubject = CurrentValueSubject<[CurrencyRateDTO], Never>([])
    var selectedCurrentCurrency: CurrencyRateDTO?
    
    // MARK: - Private Properties
    private var coreDataManager: CoreDataManager
    private var cancellables = Set<AnyCancellable>()
    private var sideOfExchange = true
    private var enteredAmount = ""
    
    // MARK: - Init
    init(coreDataManager: CoreDataManager, cancellables: Set<AnyCancellable> = Set<AnyCancellable>()) {
        self.coreDataManager = coreDataManager
        self.cancellables = cancellables
        
        bind()
    }
    
    // MARK: - Methods
    func changeTextField(enteredAmount: String) {
        self.enteredAmount = enteredAmount
        calculateCurrencyExchange(amountForCalculate: enteredAmount)
    }
    
    func currentCurrencySelection(_ currencyRate: CurrencyRateDTO) {
        selectedCurrentCurrency = currencyRate
    }
    
    func calculateCurrencyExchange(amountForCalculate: String) {
        guard let enteredAmount = Double(amountForCalculate),
              let selectedCurrencyRate = selectedCurrentCurrency?.rate,
              let bynToSelectedCurrencyRate = selectedCurrentCurrency?.scale else {
            return
        }
        
        var result = 0.0
        if sideOfExchange {
            result = (enteredAmount * selectedCurrencyRate) / bynToSelectedCurrencyRate
        } else {
            result = (enteredAmount * bynToSelectedCurrencyRate) / selectedCurrencyRate
        }
        
        amountForChangeSubject.send(result)
    }
    
    func changeCurrencyButtonTapped() {
        switch sideOfExchange {
        case true:
            self.sideOfExchange = false
        case false:
            self.sideOfExchange = true
        }
        
        if enteredAmount != "" {
            calculateCurrencyExchange(amountForCalculate: enteredAmount)
        }
        
        changingCurrenciesSubject.send(sideOfExchange)
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

