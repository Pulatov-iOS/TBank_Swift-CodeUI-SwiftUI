import UIKit

final class SettingsCoordinator {
    
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showSettingsScreen()
    }
    
    private func showSettingsScreen() {
        let view = SettingsViewController()
        let viewModel = SettingsViewModel()
        view.viewModel = viewModel
        navigationController.pushViewController(view, animated: true)
    }
}
