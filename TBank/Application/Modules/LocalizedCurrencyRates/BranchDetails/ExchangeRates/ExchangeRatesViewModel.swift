import Combine

//MARK: - Protocol for expansion ExchangeRatesViewModel. Will be worked out when the loading process will be finished

protocol ExchangeRatesViewModelProtocol: AnyObject {
    func loadData()
    var loadedCurrentCurrencies: (([Currencies]) -> (Void))? { get set}
}



//MARK: - Final class ExchangeRatesViewModel

final class ExchangeRatesViewModel {
    
    
//MARK: - Properties and init of class
    
    var currencies: [Currencies] = []
    
    var loadedCurrentCurrencies: (([Currencies]) -> (Void))?
    
}
    
    
    
//MARK: - Implemendation of the LoadingScreenPresenterProtocol

extension ExchangeRatesViewModel: ExchangeRatesViewModelProtocol {
    
    func loadData() {
        let result = CoreDataManager.instance.loadCurrancies()
        switch result {
        case .success(let data):
            self.currencies = data
            loadedCurrentCurrencies?(currencies)
        case .failure(let failure):
            print(failure.localizedDescription)
        }
    }
}
