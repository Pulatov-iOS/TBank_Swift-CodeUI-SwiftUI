import UIKit

final class RootCoordinator {
    
    // MARK: - Private Properties
    private let window: UIWindow
    private let initialNavigationController = UINavigationController()
    private let tabBar = TabBarItem()
    private var selectedTabBarItem: TypeTabBar = .left
    
    private var locCurRatesTabCoordinator: LocalizedCurrencyRatesCoordinator?
    private var currencyConverterCoordinator: CurrencyConverterCoordinator?
    private var bestCurRatesCoordinator: BestCurrencyRatesCoordinator?
    
    init(window: UIWindow) {
        self.window = window
    }
    
    // MARK: - Methods
    func start() {
        tabBar.delegate = self
        
        locCurRatesTabCoordinator = LocalizedCurrencyRatesCoordinator(navigationController: initialNavigationController, tabBar: tabBar)
        currencyConverterCoordinator = CurrencyConverterCoordinator(navigationController: initialNavigationController)
        bestCurRatesCoordinator = BestCurrencyRatesCoordinator(navigationController: initialNavigationController, tabBar: tabBar)
        
        if let coordinator = locCurRatesTabCoordinator {
            coordinator.start()
        }
        
        window.rootViewController = initialNavigationController
        window.makeKeyAndVisible()
    }
}

extension RootCoordinator: TabBarItemDelegate {
    
    func leftItemTapped(_ cell: TabBarItem) {
        if let coordinator = locCurRatesTabCoordinator, selectedTabBarItem != .left {
            tabBar.selected(.left)
            selectedTabBarItem = .left
            coordinator.start()
        }
    }
    
    func centerItemTapped(_ cell: TabBarItem) {
        if let coordinator = currencyConverterCoordinator {
            selectedTabBarItem = .center
            coordinator.start()
        }
    }
    
    func rightItemTapped(_ cell: TabBarItem) {
        if let coordinator = bestCurRatesCoordinator, selectedTabBarItem != .right {
            tabBar.selected(.right)
            selectedTabBarItem = .right
            coordinator.start()
        }
    }
}
