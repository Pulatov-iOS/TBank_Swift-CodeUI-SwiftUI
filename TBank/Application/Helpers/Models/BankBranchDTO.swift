import Foundation

struct BankBranchDTO {
    let id: Int
    let branchNumber: String
    let workingDays: String
    let workingHours: String
    let address: String
    let latitude: Double
    let longitude: Double
    let isFavorite: Bool = false
}
