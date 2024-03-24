import Foundation
import Combine

final class LocalizedCurrencyRatesViewModel {
    
    // MARK: - Public properties
    var showSettingsPage: (() -> Void)?
    var showExchangeRatesPage: (([BankBranchCurrencyRate], BankBranch) -> Void)?
    let bankBranchesSubject = CurrentValueSubject<[BankBranch], Never>([])
    let currencyRatesSubject = CurrentValueSubject<[CurrencyRateDTO], Never>([])
    let bankBranchCurrencyRateSubject = CurrentValueSubject<[BankBranchCurrencyRate], Never>([])
    let bankBranchesCurrencyRateSubject = CurrentValueSubject<[BankBranchCurrencyRate], Never>([])
    
    // MARK: - Private properties
    private var networkManager: NetworkManagerCurrency
    private var coreDataManager: CoreDataManager
    private var cancellables = Set<AnyCancellable>()
    
    init(networkManager: NetworkManagerCurrency, coreDataManager: CoreDataManager) {
        self.networkManager = networkManager
        self.coreDataManager = coreDataManager

        bind()
        updateCurrencyRates()
    }
    
    // MARK: - Methods
    func settingsButtonTapped() {
        showSettingsPage?()
    }
    
    func tableCellTapped(_ bankBranche: BankBranch) {
        let filteredObjects = bankBranchesCurrencyRateSubject.value.filter {
            $0.idBankBranch == bankBranche.id
        }
        showExchangeRatesPage?(filteredObjects, bankBranche)
    }
    
    func getCurrencyRate(idBankBranch: Int) -> Double {
        let filteredRates = bankBranchCurrencyRateSubject.value.filter { $0.idBankBranch == idBankBranch }
        return filteredRates.first?.rate ?? 0
    }
    
    private func updateCurrencyRates() {
        if !coreDataManager.isSaveBankBranches() {
            networkManager.fetchCurrencyRates { currencyRates in
                if let currencyRates = currencyRates {
                    let _ = self.coreDataManager.saveBankBranchCurrencyRate(currencyRates)
                    let _ = self.coreDataManager.saveCurrencyRates(currencyRates)
                    self.update()
                }
            }
        } else {
            if !coreDataManager.isUpdateCurrencyRates() {
                networkManager.fetchCurrencyRates { currencyRates in
                    if let currencyRates = currencyRates {
                        let _ = self.coreDataManager.updateBankBranchCurrencyRate(currencyRates)
                        let _ = self.coreDataManager.updateCurrencyRates(currencyRates)
                        self.update()
                    }
                }
            } else {
                update()
            }
        }
    }
    
    private func update() {
        let _ = self.coreDataManager.loadBankBranches()
        self.coreDataManager.loadCurrencyRates()
        self.coreDataManager.loadBankBranchCurrencyRate()
    }
    
    private func bind() {
        coreDataManager.bankBranchesSubject
            .sink { bankBranches in
                self.bankBranchesSubject.send(bankBranches)
            }
            .store(in: &cancellables)
        
        coreDataManager.currencyRatesSubject
            .sink { currencyRates in
                self.currencyRatesSubject.send(currencyRates)
            }
            .store(in: &cancellables)
        
        coreDataManager.bankBranchCurrencyRateSubject
            .sink { bankBranchCurrencyRate in
                let filteredRates = bankBranchCurrencyRate.filter { $0.abbreviation == "EUR" }
                self.bankBranchCurrencyRateSubject.send(filteredRates)
                self.bankBranchesCurrencyRateSubject.send(bankBranchCurrencyRate)
            }
            .store(in: &cancellables)
    }
}
