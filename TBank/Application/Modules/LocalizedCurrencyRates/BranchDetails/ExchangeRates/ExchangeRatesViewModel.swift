import Combine

final class ExchangeRatesViewModel {
    
    //MARK: - Public Properties
    var showBankLocatorMapPage: (() -> Void)?
    let currencyRates: [BankBranchCurrencyRate]
    let bankBranch: BankBranch

    init(currencyRates: [BankBranchCurrencyRate], bankBranch: BankBranch) {
        self.currencyRates = currencyRates
        self.bankBranch = bankBranch
    }
    
    func mapButtonTapped() {
        showBankLocatorMapPage?()
    }
}
