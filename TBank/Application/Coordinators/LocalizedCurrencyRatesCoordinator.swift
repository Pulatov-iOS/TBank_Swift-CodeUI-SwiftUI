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
        let locationManager = LocationManager.instance
        
        let view = LocalizedCurrencyRatesViewController(tabBar: tabBar)
        let viewModel = LocalizedCurrencyRatesViewModel(networkManager: networkManager, coreDataManager: coreDataManager, locationManager: locationManager)
        view.viewModel = viewModel
        navigationController.setViewControllers([view], animated: false)
        
        viewModel.showExchangeRatesPage = { [weak self] exchangeRates, bankBranch, bankBranches in
            self?.showExchangeRatesScreen(exchangeRates, bankBranch, bankBranches)
        }
        
        viewModel.showSettingsPage = { [weak self] in
            self?.settingsCoordinator?.start()
        }
    }
    
    private func showExchangeRatesScreen(_ currencyRates: [BankBranchCurrencyRate], _ bankBranch: BankBranch, _ bankBranches: [BankBranch]) {
        let view = ExchangeRatesViewController()
        let viewModel = ExchangeRatesViewModel(currencyRates: currencyRates, bankBranch: bankBranch)
        view.viewModel = viewModel
        
        viewModel.showBankLocatorMapPage = { [weak self] in
            self?.navigationController.dismiss(animated: true)
            self?.showBankLocatorMapScreen(currencyRates, bankBranch, bankBranches)
        }
    
        navigationController.modalPresentationStyle = .formSheet
        navigationController.present(view, animated: true)
    }
    
    private func showBankLocatorMapScreen(_ currencyRates: [BankBranchCurrencyRate], _ bankBranch: BankBranch, _ bankBranches: [BankBranch]) {
        
        let view = BankLocatorMapViewController()
        let viewModel = BankLocatorMapViewModel(bankBranch: bankBranch, bankBranches)
        view.viewModel = viewModel
        
        viewModel.showExchangeRatesPage = { [weak self] in
            self?.navigationController.dismiss(animated: true)
            self?.showExchangeRatesScreen(currencyRates, bankBranch, bankBranches)
        }
        
        navigationController.modalPresentationStyle = .formSheet
        navigationController.present(view, animated: true)
    }
}
