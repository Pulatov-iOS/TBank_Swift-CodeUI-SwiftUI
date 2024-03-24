import UIKit

final class LocalizedCurrencyRatesCoordinator {
    
    let navigationController: UINavigationController
    let tabBar: TabBarItem
    
    private var settingsCoordinator: SettingsCoordinator?
    
    init(navigationController: UINavigationController, tabBar: TabBarItem) {
        self.navigationController = navigationController
        self.tabBar = tabBar
        settingsCoordinator = SettingsCoordinator(navigationController: self.navigationController)
    }
    
    func start() {
        showLocalizedCurrencyRatesScreen()
    }
    
    private func showLocalizedCurrencyRatesScreen() {
        let networkManager = NetworkManagerCurrency.instance
        let coreDataManager = CoreDataManager.instance
        
        let view = LocalizedCurrencyRatesViewController(tabBar: tabBar)
        let viewModel = LocalizedCurrencyRatesViewModel(networkManager: networkManager, coreDataManager: coreDataManager)
        view.viewModel = viewModel
        navigationController.setViewControllers([view], animated: false)
        
        viewModel.showSettingsPage = { [weak self] in
            self?.settingsCoordinator?.start()
        }
    }
}
