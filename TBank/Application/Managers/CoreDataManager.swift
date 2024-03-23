import CoreData
import UIKit


//MARK: - Final class CoreDataManager
final class CoreDataManager: NSCopying {
    
    static let instance = CoreDataManager()
    private init() { }
    
    func copy(with zone: NSZone? = nil) -> Any {
        self
    }
    
    //MARK: - Saving of currancy location
    func saveCurrency(name: String, rate: Double, dynamic: Double) -> Result<Void, CoreDataError> {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return .failure(.appDelegateError) }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        guard let currancyEntity = NSEntityDescription.entity(forEntityName: "Currencies", in: managedContext) else { return .failure(.entityError) }
        
        let currency = NSManagedObject(entity: currancyEntity, insertInto: managedContext)
        
        currency.setValue(name, forKey: "name")
        currency.setValue(rate, forKey: "rate")
        currency.setValue(dynamic, forKey: "dynamic")
        
        do {
            try managedContext.save()
        } catch {
            print("ERROR - \(error.localizedDescription)")
            print("Core Data validation error: \(error)")
            return .failure(.saveError)
        }
        
        return .success(())
    }
  
    //MARK: - Loading of Currencies array
    func loadCurrancies() -> Result<[Currencies], CoreDataError> {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return .failure(.appDelegateError) }
        
        let managedContext  = appDelegate.persistentContainer.viewContext
        
        let feetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Currencies")
        
        var currancies = [Currencies]()
        
        do {
            let feetchedObject = try managedContext.fetch(feetchRequest)
            guard let feetchedCurrancies = feetchedObject as? [Currencies] else { return .failure(.castError) }
            currancies = feetchedCurrancies
        } catch {
            return .failure(.loadError)
        }
        
        return .success(currancies)
    }
    
    //MARK: - Delete data method
    func deleteData(of object: Currencies) -> Result<Void, CoreDataError> {
        
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
}
