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
        
        viewModel.showExchangeRatesPage = { [weak self] exchangeRates, bankBranche in
            self?.showExchangeRatesScreen(exchangeRates, bankBranche)
        }
        
        viewModel.showSettingsPage = { [weak self] in
            self?.settingsCoordinator?.start()
        }
    }
    
    private func showExchangeRatesScreen(_ currencyRates: [BankBranchCurrencyRate], _ bankBranche: BankBranch) {
        let view = ExchangeRatesViewController()
        let viewModel = ExchangeRatesViewModel(currencyRates: currencyRates)
        view.viewModel = viewModel
        
        viewModel.showBankLocatorMapPage = { [weak self] in
            self?.navigationController.dismiss(animated: false)
            self?.showBankLocatorMapScreen(currencyRates, bankBranche)
        }
    
        navigationController.modalPresentationStyle = .formSheet
        navigationController.present(view, animated: true)
    }
    
    private func showBankLocatorMapScreen(_ currencyRates: [BankBranchCurrencyRate], _ bankBranche: BankBranch) {
        
        let view = BankLocatorMapViewController()
        let viewModel = BankLocatorMapViewModel(currencyRates: currencyRates, bankBranche: bankBranche)
        view.viewModel = viewModel
        
        viewModel.showExchangeRatesPage = { [weak self] in
            self?.navigationController.dismiss(animated: false)
            self?.showExchangeRatesScreen(currencyRates, bankBranche)
        }
        
        navigationController.modalPresentationStyle = .formSheet
        navigationController.present(view, animated: false)
    }
}
