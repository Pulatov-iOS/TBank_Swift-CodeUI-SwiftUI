import UIKit

final class RootCoordinator {
    
    let window: UIWindow
       
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let tabBarController = UITabBarController()
              
        let LocCurRatesNavigationController = UINavigationController()
        let LocCurRatesTabCoordinator = LocalizedCurrencyRatesCoordinator(navigationController: LocCurRatesNavigationController)
        LocCurRatesNavigationController.tabBarItem = UITabBarItem(title: NSLocalizedString("App.TabBar.CurrencyRatesItemTitle", comment: ""), image: nil, tag: 0)
        LocCurRatesTabCoordinator.start()
        
        let BestCurRatesNavigationController = UINavigationController()
        let BestCurRatesTabCoordinator = BestCurrencyRatesCoordinator(navigationController: BestCurRatesNavigationController)
        BestCurRatesNavigationController.tabBarItem = UITabBarItem(title: NSLocalizedString("App.TabBar.BestCurrencyRatesItemTitle", comment: ""), image: nil, tag: 0)
        BestCurRatesTabCoordinator.start()
        
        tabBarController.setViewControllers([LocCurRatesNavigationController, BestCurRatesNavigationController], animated: false)
        
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }

}
