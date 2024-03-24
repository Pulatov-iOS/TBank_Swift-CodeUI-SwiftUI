import Combine

final class ExchangeRatesViewModel {
    
    //MARK: - Private Properties
    var showBankLocatorMapPage: (() -> Void)?
    private let bankBranche: BankBranch
    private let currencyRates: [BankBranchCurrencyRate]
    
    // MARK: - Private properties

    
    init(currencyRates: [BankBranchCurrencyRate], bankBranche: BankBranch) {
        self.bankBranche = bankBranche
        self.currencyRates = currencyRates
    }
    
    func mapButtonTapped() {
        showBankLocatorMapPage?()
    }
}
