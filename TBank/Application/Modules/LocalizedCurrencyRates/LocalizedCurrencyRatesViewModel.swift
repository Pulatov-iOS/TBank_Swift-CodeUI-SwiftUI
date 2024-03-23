import Foundation

final class LocalizedCurrencyRatesViewModel {
    
    // MARK: - Public properties
    var currencyRates: [CurrencyRate] = []
    var showSettingsPage: (() -> Void)?
    
    // MARK: - Private properties
    private var networkManager: NetworkManagerCurrency
    
    init(networkManager: NetworkManagerCurrency) {
        self.networkManager = networkManager
    }
    
    // MARK: - Methods
    func fetchExchangeRates(completion: @escaping (Error?) -> Void) {
        networkManager.fetchExchangeRates { [weak self] ratesOrNil in
            guard let rates = ratesOrNil else {
                completion(NSError(domain: "NetworkError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch exchange rates"]))
                return
            }
            self?.currencyRates = rates
            completion(nil)
        }
    }
    
    func settingsButtonTapped() {
        showSettingsPage?()
    }
}
