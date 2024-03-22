//MARK: - Enum with errors and there descriptions for CoreData

enum CoreDataError: Error {
    case appDelegateError
    case entityError
    case saveError
    case castError
    case loadError
    
    
    //Creating the description of the error
    func description() -> String {
        switch self {
        case .appDelegateError:
            return "AppDelegate not found"
        case .entityError:
            return "Entity not found"
        case .saveError:
            return "Could not save context"
        case .castError:
            return "Could not cast context"
        case .loadError:
            return "Could not load context"
        }
    }
}
