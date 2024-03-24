import Combine

final class CurrencyConverterViewModel {
    let amountForChangeSubject = PassthroughSubject<Double, Never>()
    let currencyForChangeSubject = PassthroughSubject<String, Never>()
    let currenceForCalculateSubject = PassthroughSubject<String, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    init(cancellables: Set<AnyCancellable> = Set<AnyCancellable>()) {
        self.cancellables = cancellables
    }
    
    func changeTextField(enteredAmount: String) {
        calculateCurrencyExchange(amountForCalculate: enteredAmount, currencyRate: 3.23)
    }
    
    func calculateCurrencyExchange(amountForCalculate: String, currencyRate: Double) {
        let result = (Double(amountForCalculate) ?? 0) * currencyRate
        
        amountForChangeSubject.send(result)
    }
}

