import UIKit

final class BestCurrencyRatesCoordinator {
    
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showBestCurrencyRatesScreen()
    }
    
    private func showBestCurrencyRatesScreen() {
        let view = BestCurrencyRatesViewController()
        let viewModel = BestCurrencyRatesViewModel()
        view.viewModel = viewModel
        navigationController.setViewControllers([view], animated: false)
    }
    
}
