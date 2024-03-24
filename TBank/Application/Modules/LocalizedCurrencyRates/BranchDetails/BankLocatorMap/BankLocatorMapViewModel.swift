import Combine

final class BankLocatorMapViewModel {
    
    //MARK: - Private Properties
    var showExchangeRatesPage: (() -> Void)?
    private let bankBranche: BankBranch
    private let currencyRates: [BankBranchCurrencyRate]
    
    init(currencyRates: [BankBranchCurrencyRate], bankBranche: BankBranch) {
        self.bankBranche = bankBranche
        self.currencyRates = currencyRates
    }
    
    
    func exchangeRatesButtonTapped() {
        showExchangeRatesPage?()
    }
}
