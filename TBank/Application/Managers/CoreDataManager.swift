import CoreData
import UIKit
import Combine

final class CoreDataManager: NSCopying {
    
    static let instance = CoreDataManager()
    private init() { }
    
    // MARK: - Public Properties
    let currencyRatesSubject = CurrentValueSubject<[CurrencyRateDTO], Never>([])
    let bankBranchCurrencyRateSubject = CurrentValueSubject<[BankBranchCurrencyRate], Never>([])
    let bankBranchesSubject = CurrentValueSubject<[BankBranch], Never>([])
    
    // MARK: - Private Properties
    private let dataUpdateKey = "LastDataUpdateTime"
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
    
    func isSaveBankBranches() -> Bool {
        let isFirstLaunch = UserDefaults.standard.bool(forKey: "HasLaunchedBefore")
        if !isFirstLaunch {
            UserDefaults.standard.set(true, forKey: "HasLaunchedBefore")
            saveBankBranches()
            return false
        } else {
            return true
        }
    }
    
    func isUpdateCurrencyRates() -> Bool {
        if let lastUpdateTimeString = UserDefaults.standard.string(forKey: dataUpdateKey),
           let lastUpdateTime = dateFormatter.date(from: lastUpdateTimeString) {
            if Calendar.current.isDateInToday(lastUpdateTime) {
                return true
            } else {
                return false
            }
        }
        return false
    }
    
    func saveCurrencyRates(_ currencyRatesDTO: [CurrencyRateDTO]) -> Result<Void, CoreDataError> {
        
        for currencyRate in currencyRatesDTO {
            
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return .failure(.appDelegateError)
            }
            let managedContext = appDelegate.persistentContainer.viewContext
            
            guard let currancyRateEntity = NSEntityDescription.entity(forEntityName: "CurrencyRate", in: managedContext) else { return .failure(.entityError) }
            
            let curRate = NSManagedObject(entity: currancyRateEntity, insertInto: managedContext)
            
            curRate.setValue(currencyRate.abbreviation, forKey: "abbreviation")
            curRate.setValue(currencyRate.curName, forKey: "curName")
            curRate.setValue(currencyRate.rate, forKey: "rate")
            curRate.setValue(1000000, forKey: "lastRate")
            curRate.setValue(currencyRate.scale, forKey: "scale")
            
            do {
                try managedContext.save()
            } catch {
                print("ERROR - \(error.localizedDescription)")
                return .failure(.saveError)
            }
        }
        
        let currentDate = Date()
        let currentTimeString = dateFormatter.string(from: currentDate)
        UserDefaults.standard.set(currentTimeString, forKey: dataUpdateKey)
        
        return .success(())
    }
    
    func saveBankBranchCurrencyRate(_ currencyRatesDTO: [CurrencyRateDTO]) -> Result<Void, CoreDataError> {
        
        let bankBranchesCurrencyRateDTO = getNewBankBranchCurrencyRate(currencyRatesDTO)
        
        for bankBranchCurrencyRateDTO in bankBranchesCurrencyRateDTO {
            
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return .failure(.appDelegateError)
            }
            let managedContext = appDelegate.persistentContainer.viewContext
            
            guard let bankBranchesCurrancyRateEntity = NSEntityDescription.entity(forEntityName: "BankBranchCurrencyRate", in: managedContext) else { return .failure(.entityError) }
            
            let curRate = NSManagedObject(entity: bankBranchesCurrancyRateEntity, insertInto: managedContext)
            
            curRate.setValue(bankBranchCurrencyRateDTO.idBankBranch, forKey: "idBankBranch")
            curRate.setValue(bankBranchCurrencyRateDTO.abbreviation, forKey: "abbreviation")
            curRate.setValue(bankBranchCurrencyRateDTO.curName, forKey: "curName")
            curRate.setValue(bankBranchCurrencyRateDTO.rate, forKey: "rate")
            curRate.setValue(bankBranchCurrencyRateDTO.scale, forKey: "scale")
            
            do {
                try managedContext.save()
            } catch {
                print("ERROR - \(error.localizedDescription)")
                return .failure(.saveError)
            }
        }
        return .success(())
    }
    
    func updateCurrencyRates(_ currencyRatesDTO: [CurrencyRateDTO]) -> Result<Void, CoreDataError> {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return .failure(.appDelegateError)
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        for currencyRate in currencyRatesDTO {
            let fetchRequest: NSFetchRequest<CurrencyRate> = CurrencyRate.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "abbreviation == %@", currencyRate.abbreviation)
            
            do {
                let results = try managedContext.fetch(fetchRequest)
                
                if let existingCurrencyRate = results.first {
                    existingCurrencyRate.curName = currencyRate.curName
                    existingCurrencyRate.rate = currencyRate.rate
                    existingCurrencyRate.lastRate = existingCurrencyRate.rate
                    existingCurrencyRate.scale = currencyRate.scale
                } else {
                    guard let entity = NSEntityDescription.entity(forEntityName: "CurrencyRate", in: managedContext) else {
                        return .failure(.entityError)
                    }
                    
                    let newCurrencyRate = CurrencyRate(entity: entity, insertInto: managedContext)
                    newCurrencyRate.abbreviation = currencyRate.abbreviation
                    newCurrencyRate.curName = currencyRate.curName
                    newCurrencyRate.rate = currencyRate.rate
                    newCurrencyRate.lastRate = 1000000
                    newCurrencyRate.scale = currencyRate.scale
                }
            } catch {
                print("ERROR - \(error.localizedDescription)")
                return .failure(.updateError)
            }
        }
        
        do {
            try managedContext.save()
            
            let currentDate = Date()
            let currentTimeString = dateFormatter.string(from: currentDate)
            UserDefaults.standard.set(currentTimeString, forKey: dataUpdateKey)
            
            return .success(())
        } catch {
            print("ERROR - \(error.localizedDescription)")
            return .failure(.updateError)
        }
    }
    
    func updateBankBranchCurrencyRate(_ currencyRatesDTO: [CurrencyRateDTO]) -> Result<Void, CoreDataError> {
        
        let bankBranchesCurrencyRateDTO = getNewBankBranchCurrencyRate(currencyRatesDTO)
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return .failure(.appDelegateError)
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        for bankBranchCurrencyRateDTO in bankBranchesCurrencyRateDTO {
            let fetchRequest: NSFetchRequest<BankBranchCurrencyRate> = BankBranchCurrencyRate.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "abbreviation == %@", bankBranchCurrencyRateDTO.abbreviation)
            
            do {
                let results = try managedContext.fetch(fetchRequest)
                
                if let existingBankBranchCurrencyRate = results.first {
                    existingBankBranchCurrencyRate.idBankBranch = Int64(bankBranchCurrencyRateDTO.idBankBranch)
                    existingBankBranchCurrencyRate.curName = bankBranchCurrencyRateDTO.curName
                    existingBankBranchCurrencyRate.rate = bankBranchCurrencyRateDTO.rate
                    existingBankBranchCurrencyRate.scale = bankBranchCurrencyRateDTO.scale
                } else {
                    guard let entity = NSEntityDescription.entity(forEntityName: "BankBranchCurrencyRate", in: managedContext) else {
                        return .failure(.entityError)
                    }
                    
                    let newBankBranchCurrencyRate = BankBranchCurrencyRate(entity: entity, insertInto: managedContext)
                    newBankBranchCurrencyRate.idBankBranch = Int64(bankBranchCurrencyRateDTO.idBankBranch)
                    newBankBranchCurrencyRate.abbreviation = bankBranchCurrencyRateDTO.abbreviation
                    newBankBranchCurrencyRate.curName = bankBranchCurrencyRateDTO.curName
                    newBankBranchCurrencyRate.rate = bankBranchCurrencyRateDTO.rate
                    newBankBranchCurrencyRate.scale = bankBranchCurrencyRateDTO.scale
                }
            } catch {
                print("ERROR - \(error.localizedDescription)")
                return .failure(.updateError)
            }
        }
        
        do {
            try managedContext.save()
            return .success(())
        } catch {
            print("ERROR - \(error.localizedDescription)")
            return .failure(.updateError)
        }
    }
    
    func loadBankBranches() -> [BankBranch] {
        var bankBranch = [BankBranch]()
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return [] }
        let managedContext  = appDelegate.persistentContainer.viewContext
        let feetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BankBranch")
        
        do {
            let feetchedObject = try managedContext.fetch(feetchRequest)
            guard let feetchedBankBranch = feetchedObject as? [BankBranch] else { return [] }
            bankBranch = feetchedBankBranch
        } catch {
            return []
        }
        
        bankBranchesSubject.send(bankBranch)
        return bankBranch
    }
  
    func loadCurrencyRates() {
        var currencyRates = [CurrencyRate]()
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext  = appDelegate.persistentContainer.viewContext
        let feetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CurrencyRate")
        
        do {
            let feetchedObject = try managedContext.fetch(feetchRequest)
            guard let feetchedCurrencyRates = feetchedObject as? [CurrencyRate] else { return }
            currencyRates = feetchedCurrencyRates
        } catch {
            return
        }
        
        var currencyRatesDTO = [CurrencyRateDTO]()
        for currencyRate in currencyRates {
            let currencyRateDTO = CurrencyRateDTO(abbreviation: currencyRate.abbreviation ?? "", curName: currencyRate.curName ?? "", rate: currencyRate.rate, lastRate: currencyRate.lastRate, scale: currencyRate.scale)
            currencyRatesDTO.append(currencyRateDTO)
        }
        
        currencyRatesSubject.send(currencyRatesDTO)
    }
    
    func loadBankBranchCurrencyRate() {
        var bankBranchCurrencyRates = [BankBranchCurrencyRate]()
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext  = appDelegate.persistentContainer.viewContext
        let feetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BankBranchCurrencyRate")
        
        do {
            let feetchedObject = try managedContext.fetch(feetchRequest)
            guard let feetchedBankBranchCurrencyRates = feetchedObject as? [BankBranchCurrencyRate] else { return
            }
            bankBranchCurrencyRates = feetchedBankBranchCurrencyRates
        } catch {
            return
        }
        
        bankBranchCurrencyRateSubject.send(bankBranchCurrencyRates)
    }
    
    func deleteCurrencyRates(of object: CurrencyRate) -> Result<Void, CoreDataError> {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return .failure(.appDelegateError) }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        managedContext.delete(object)
        
        do {
            try managedContext.save()
        } catch {
            return .failure(.saveError)
        }
        return .success(())
    }
    
    func saveBankBranches() {
        let bankBranchs: [BankBranchDTO] = [
            BankBranchDTO(id: 1000001, branchNumber: "501", workingDays: "101", workingHours: "9:00 - 18:00", address: "101", latitude: 53.882507, longitude: 27.508025),
            BankBranchDTO(id: 1000002, branchNumber: "502", workingDays: "101", workingHours: "9:00 - 17:00", address: "102", latitude: 53.929086, longitude: 27.587694),
            BankBranchDTO(id: 1000003, branchNumber: "503", workingDays: "102", workingHours: "9:00 - 17:00", address: "103", latitude: 53.862998, longitude: 27.603746),
            BankBranchDTO(id: 1000004, branchNumber: "504", workingDays: "101", workingHours: "9:00 - 18:00", address: "104", latitude: 53.859585, longitude: 27.674710),
            BankBranchDTO(id: 1000005, branchNumber: "505", workingDays: "102", workingHours: "10:00 - 17:00", address: "105", latitude: 53.959294, longitude: 27.537586),
            BankBranchDTO(id: 1000006, branchNumber: "506", workingDays: "101", workingHours: "9:00 - 17:00", address: "106", latitude: 53.951649, longitude: 27.605884),
            BankBranchDTO(id: 1000007, branchNumber: "507", workingDays: "101", workingHours: "10:00 - 18:00", address: "107", latitude: 53.901329, longitude: 27.559783),
            BankBranchDTO(id: 1000008, branchNumber: "508", workingDays: "101", workingHours: "9:00 - 17:00", address: "108", latitude: 53.835096, longitude: 27.606156),
            BankBranchDTO(id: 1000009, branchNumber: "509", workingDays: "102", workingHours: "9:00 - 20:00", address: "109", latitude: 53.871970, longitude: 27.572756),
            BankBranchDTO(id: 1000010, branchNumber: "510", workingDays: "101", workingHours: "10:00 - 19:00", address: "110", latitude: 53.910134, longitude: 27.634136),
            BankBranchDTO(id: 1000011, branchNumber: "511", workingDays: "101", workingHours: "9:00 - 17:00", address: "111", latitude: 53.933823, longitude: 27.653309),
            BankBranchDTO(id: 1000012, branchNumber: "512", workingDays: "101", workingHours: "9:00 - 17:00", address: "112", latitude: 53.908670, longitude: 27.432330),
            BankBranchDTO(id: 1000013, branchNumber: "513", workingDays: "101", workingHours: "9:00 - 17:00", address: "113", latitude: 53.943260, longitude: 27.461247),
            BankBranchDTO(id: 1000014, branchNumber: "514", workingDays: "101", workingHours: "10:00 - 17:00", address: "114", latitude: 53.863593, longitude: 27.482474),
            BankBranchDTO(id: 1000015, branchNumber: "515", workingDays: "101", workingHours: "9:00 - 17:00", address: "115", latitude: 53.842438, longitude: 27.529222)
        ]
        
        for bank in bankBranchs {

            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let managedContext = appDelegate.persistentContainer.viewContext
            
            guard let bankBranchEntity = NSEntityDescription.entity(forEntityName: "BankBranch", in: managedContext) else { return }
            
            let bankBranch = NSManagedObject(entity: bankBranchEntity, insertInto: managedContext)
            
            bankBranch.setValue(bank.id, forKey: "id")
            bankBranch.setValue(bank.branchNumber, forKey: "branchNumber")
            bankBranch.setValue(bank.workingDays, forKey: "workingDays")
            bankBranch.setValue(bank.workingHours, forKey: "workingHours")
            bankBranch.setValue(bank.address, forKey: "address")
            bankBranch.setValue(bank.latitude, forKey: "latitude")
            bankBranch.setValue(bank.longitude, forKey: "longitude")
            bankBranch.setValue(bank.isFavorite, forKey: "isFavorite")
            
            do {
                try managedContext.save()
            } catch {
                print("Core Data validation error: \(error)")
                return
            }
        }
    }
    
    private func getNewBankBranchCurrencyRate(_ currencyRatesDTO: [CurrencyRateDTO]) -> [BankBranchCurrencyRateDTO] {
        
        var bankBranchesCurrencyRateDTO: [BankBranchCurrencyRateDTO] = []
        var bankBranches = loadBankBranches()
        
        for bankBranch in bankBranches {
            
            for currencyRateDTO in currencyRatesDTO {
                var rate = currencyRateDTO.rate
                let randomPercentageChange = Double.random(in: -0.5...0.5) / 100.0
                let result = rate + (Double(rate) * randomPercentageChange)
                
                bankBranchesCurrencyRateDTO.append(BankBranchCurrencyRateDTO(
                    idBankBranch: Int(bankBranch.id),
                    abbreviation: currencyRateDTO.abbreviation,
                    curName: currencyRateDTO.curName,
                    rate: result,
                    scale: currencyRateDTO.scale)
                )
            }
        }
        
        return bankBranchesCurrencyRateDTO
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        self
    }
}
