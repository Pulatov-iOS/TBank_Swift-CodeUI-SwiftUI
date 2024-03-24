import Foundation

struct CurrencyRateDTO: Decodable {
    let abbreviation: String
    let curName: String
    let rate: Double
    let lastRate: Double?
    let scale: Double
    
    enum CodingKeys: String, CodingKey {
        case abbreviation = "Cur_Abbreviation"
        case curName = "Cur_Name"
        case rate = "Cur_OfficialRate"
        case scale = "Cur_Scale"
        case lastRate = "Last_Rate"
    }
}
