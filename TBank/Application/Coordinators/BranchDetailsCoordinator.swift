import UIKit

final class BranchDetailsCoordinator {
    
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showLocalizedCurrencyRatesScreen()
    }
    
    private func showLocalizedCurrencyRatesScreen() {
        let coreDataManager = CoreDataManager.instance
        
        let view = ExchangeRatesView()
        let viewModel = ExchangeRatesViewModel(coreDataManager: coreDataManager)
        view.viewModel = viewModel
        navigationController.setViewControllers([view], animated: false)
    }
}
