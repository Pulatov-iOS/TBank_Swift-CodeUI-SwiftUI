import UIKit

final class BestCurrencyRatesCoordinator {
    
    let navigationController: UINavigationController
    let tabBar: TabBarItem
    
    init(navigationController: UINavigationController, tabBar: TabBarItem) {
        self.navigationController = navigationController
        self.tabBar = tabBar
    }
    
    func start() {
        showBestCurrencyRatesScreen()
    }
    
    private func showBestCurrencyRatesScreen() {
        let view = BestCurrencyRatesViewController(tabBar: tabBar)
        let viewModel = BestCurrencyRatesViewModel()
        view.viewModel = viewModel
        navigationController.setViewControllers([view], animated: false)
    }
}
