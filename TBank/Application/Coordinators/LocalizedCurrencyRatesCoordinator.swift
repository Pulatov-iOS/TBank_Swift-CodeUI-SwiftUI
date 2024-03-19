import UIKit

final class LocalizedCurrencyRatesCoordinator {
    
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showLocalizedCurrencyRatesScreen()
    }
    
    private func showLocalizedCurrencyRatesScreen() {
        let view = LocalizedCurrencyRatesViewController()
        let viewModel = LocalizedCurrencyRatesViewModel()
        view.viewModel = viewModel
        navigationController.setViewControllers([view], animated: false)
    }
    
}
