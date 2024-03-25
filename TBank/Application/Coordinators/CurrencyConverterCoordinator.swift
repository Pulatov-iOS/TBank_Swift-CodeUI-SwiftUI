import UIKit

final class CurrencyConverterCoordinator {
    
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showCurrencyConverterScreen()
    }
    
    private func showCurrencyConverterScreen() {
        let coreDataManager = CoreDataManager.instance
        
        let view = CurrencyConverterViewController()
        let viewModel = CurrencyConverterViewModel(coreDataManager: coreDataManager)
        view.viewModel = viewModel
        
        navigationController.modalPresentationStyle = .formSheet
        navigationController.present(view, animated: true)
    }
}
