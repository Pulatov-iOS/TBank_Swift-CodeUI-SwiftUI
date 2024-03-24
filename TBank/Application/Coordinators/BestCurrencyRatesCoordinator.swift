import UIKit

final class BestCurrencyRatesCoordinator {
    
    let navigationController: UINavigationController
    let tabBar: TabBarItem
    
    private var settingsCoordinator: SettingsCoordinator?
    
    init(navigationController: UINavigationController, tabBar: TabBarItem) {
        self.navigationController = navigationController
        self.tabBar = tabBar
        settingsCoordinator = SettingsCoordinator(navigationController: self.navigationController)
    }
    
    func start() {
        showBestCurrencyRatesScreen()
    }
    
    private func showBestCurrencyRatesScreen() {
        let networkManager = NetworkManagerCurrency.instance
        let coreDataManager = CoreDataManager.instance
        
        let view = BestCurrencyRatesViewController(tabBar: tabBar)
        let viewModel = BestCurrencyRatesViewModel(networkManager: networkManager, coreDataManager: coreDataManager)
        view.viewModel = viewModel
        navigationController.setViewControllers([view], animated: false)
        
        viewModel.showSettingsPage = { [weak self] in
            self?.settingsCoordinator?.start()
        }
    }
}
