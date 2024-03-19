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
        let view = CurrencyConverterViewController()
        let viewModel = CurrencyConverterViewModel()
        view.viewModel = viewModel
        navigationController.popToViewController(view, animated: true)
    }
    
}
