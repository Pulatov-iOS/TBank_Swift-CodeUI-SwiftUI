import Combine

final class BankLocatorMapViewModel {
    
    //MARK: - Public Properties
    let bankBranch: BankBranch
    let bankBranches: [BankBranch]
    
    //MARK: - Private Properties
    var showExchangeRatesPage: (() -> Void)?
    
    init(bankBranch: BankBranch, _ bankBranches: [BankBranch]) {
        self.bankBranch = bankBranch
        self.bankBranches = bankBranches
    }
    
    func exchangeRatesButtonTapped() {
        showExchangeRatesPage?()
    }
}
