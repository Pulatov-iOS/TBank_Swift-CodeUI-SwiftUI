import Alamofire
import Foundation

final class NetworkManagerCurrency: NSCopying {
    
    static let instance = NetworkManagerCurrency()
    private let url = "https://www.nbrb.by/api/exrates/rates?periodicity=0"
    
    private init() { }
    
    func fetchCurrencyRates(completion: @escaping ([CurrencyRateDTO]?) -> Void) {
        AF.request(url).responseDecodable(of: [CurrencyRateDTO].self) { response in
            switch response.result {
            case .success(let rates):
                completion(rates)
            case .failure(let error):
                print("Error fetching exchange rates: \(error)")
                completion(nil)
            }
        }
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        return NetworkManagerCurrency.instance
    }
}
