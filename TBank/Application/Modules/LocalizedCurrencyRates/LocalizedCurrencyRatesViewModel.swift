import Foundation

final class LocalizedCurrencyRatesViewModel {
    private var networkManager: NetworkManagerCurrency
    
    var currencyRates: [CurrencyRate] = []
    
    init(networkManager: NetworkManagerCurrency) {
        self.networkManager = networkManager
    }
    
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
}
