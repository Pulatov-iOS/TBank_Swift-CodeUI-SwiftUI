import Combine

final class ExchangeRatesViewModel {
    
    //MARK: - Private Properties
    var showBankLocatorMapPage: (() -> Void)?
    let currencyRates: [BankBranchCurrencyRate]
    
    // MARK: - Private properties

    init(currencyRates: [BankBranchCurrencyRate]) {
        self.currencyRates = currencyRates
    }
    
    func mapButtonTapped() {
        showBankLocatorMapPage?()
    }
}
