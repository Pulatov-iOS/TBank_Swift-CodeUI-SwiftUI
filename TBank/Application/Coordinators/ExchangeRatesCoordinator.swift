import UIKit

final class ExchangeRatesCoordinator {
    
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showLocalizedCurrencyRatesScreen()
    }
    
    private func showLocalizedCurrencyRatesScreen() {
        let view = ExchangeRatesView()
        let viewModel = ExchangeRatesViewModel()
        view.viewModel = viewModel
        navigationController.setViewControllers([view], animated: false)
    }
}
