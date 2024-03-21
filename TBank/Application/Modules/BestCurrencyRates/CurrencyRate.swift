import Foundation

struct CurrencyRate: Decodable {
    let abbreviation: String
    let curName: String
    let rate: Double
    let scale: Double
    
    
    enum CodingKeys: String, CodingKey {
        case abbreviation = "Cur_Abbreviation"
        case curName = "Cur_Name"
        case rate = "Cur_OfficialRate"
        case scale = "Cur_Scale"
    }
}
