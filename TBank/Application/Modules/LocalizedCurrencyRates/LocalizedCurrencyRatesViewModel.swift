import Foundation
import CoreLocation
import Combine

final class LocalizedCurrencyRatesViewModel {
    
    // MARK: - Public properties
    var showSettingsPage: (() -> Void)?
    var showExchangeRatesPage: (([BankBranchCurrencyRate], BankBranch) -> Void)?
    let bankBranchesSubject = CurrentValueSubject<[BankBranch], Never>([])
    let currencyRatesSubject = CurrentValueSubject<[CurrencyRateDTO], Never>([])
    let bankBranchCurrencyRateSubject = CurrentValueSubject<[BankBranchCurrencyRate], Never>([])
    let bankBranchesCurrencyRateSubject = CurrentValueSubject<[BankBranchCurrencyRate], Never>([])
    var currentCurrency = "USD"
    var currentTypeSorting: TypeSorting = .nearest
    
    // MARK: - Private properties
    private var networkManager: NetworkManagerCurrency
    private var coreDataManager: CoreDataManager
    private var locationManager: LocationManager
    private var originalBankBranches: [BankBranch] = []
    private var currentLocation: [Double] = [0.0, 0.0]
    private var cancellables = Set<AnyCancellable>()
    
    init(networkManager: NetworkManagerCurrency, coreDataManager: CoreDataManager, locationManager: LocationManager) {
        self.networkManager = networkManager
        self.coreDataManager = coreDataManager
        self.locationManager = locationManager
  
        bind()
        updateCurrencyRates()
        loadCurrentTypeSorting()
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
    
    func changeCurrencyType(_ newCurrencyType: String) {
        currentCurrency = newCurrencyType
        let filteredRates = self.bankBranchesCurrencyRateSubject.value.filter { $0.abbreviation == self.currentCurrency }
        self.bankBranchCurrencyRateSubject.send(filteredRates)
    }
    
    func changeSortingType(typeOfSotring: TypeSorting) {
        switch typeOfSotring {
        case .nearest:
            let currentLocation = CLLocation(latitude: currentLocation[0], longitude: currentLocation[1])

            let filteredBankBranch = originalBankBranches.sorted {
                let pointLocation = CLLocation(latitude: $0.latitude, longitude: $0.longitude)
                let distanceToCurrent = pointLocation.distance(from: currentLocation)
                
                let nextPointLocation = CLLocation(latitude: $1.latitude, longitude: $1.longitude)
                let distanceToNext = nextPointLocation.distance(from: currentLocation)
                
                return distanceToCurrent < distanceToNext
            }
            
            currentTypeSorting = typeOfSotring
            bankBranchesSubject.send(filteredBankBranch)
            
        case .bestCourse:
            var filteredRates = bankBranchesCurrencyRateSubject.value.filter { $0.abbreviation == self.currentCurrency }
            filteredRates = filteredRates.sorted { $0.rate < $1.rate }
            
            let filteredBankBranch = originalBankBranches.sorted { bank1, bank2 in
                let rate1 = filteredRates.first(where: { $0.idBankBranch == bank1.id })?.rate ?? 0
                let rate2 = filteredRates.first(where: { $0.idBankBranch == bank2.id })?.rate ?? 0
                return rate1 < rate2
            }
            
            currentTypeSorting = typeOfSotring
            bankBranchesSubject.send(filteredBankBranch)
            
        case .favorites:
            let filteredBankBranch = originalBankBranches.filter { $0.isFavorite == true }
            currentTypeSorting = typeOfSotring
            bankBranchesSubject.send(filteredBankBranch)
        }
    }
    
    func favoritesButtonTapped(_ bankBranche: BankBranch) {
        coreDataManager.updateBankBranchFavoriteStatus(bankBranch: bankBranche)
    }

    func loadCurrentTypeSorting() {
        if let savedCurrentTypeSorting = UserDefaults.standard.string(forKey: "currentTypeSorting"),
           let currentTypeSorting = TypeSorting(rawValue: savedCurrentTypeSorting) {
            self.currentTypeSorting = currentTypeSorting
        }
        else {
            self.currentTypeSorting = .nearest
        }
        changeSortingType(typeOfSotring: currentTypeSorting)
    }
    
    func saveCurrentTypeSorting() {
        UserDefaults.standard.set(currentTypeSorting.rawValue, forKey: "currentTypeSorting")
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
                self.originalBankBranches = bankBranches
                self.bankBranchesSubject.send(bankBranches)
                self.changeSortingType(typeOfSotring: self.currentTypeSorting)
            }
            .store(in: &cancellables)
        
        coreDataManager.currencyRatesSubject
            .sink { currencyRates in
                self.currencyRatesSubject.send(currencyRates)
            }
            .store(in: &cancellables)
        
        coreDataManager.bankBranchCurrencyRateSubject
            .sink { bankBranchCurrencyRate in
                let filteredRates = bankBranchCurrencyRate.filter { $0.abbreviation == self.currentCurrency }
                self.bankBranchCurrencyRateSubject.send(filteredRates)
                self.bankBranchesCurrencyRateSubject.send(bankBranchCurrencyRate)
            }
            .store(in: &cancellables)
        
        locationManager.currentLocationSubject
            .sink { currentLocation in
                self.currentLocation[0] = currentLocation[0]
                self.currentLocation[1] = currentLocation[1]
                if self.currentTypeSorting == .nearest {
                    self.changeSortingType(typeOfSotring: .nearest)
                }
            }
            .store(in: &cancellables)
    }
}
