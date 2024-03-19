import UIKit
import SnapKit

final class BestCurrencyRatesViewController: UIViewController {
    
    // MARK: - Public Properties
    var viewModel: BestCurrencyRatesViewModel!
    
    // MARK: - LyfeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
        configureConstraints()
        configureUI()
        bindings()
    }
    
    // MARK: - Methods
    private func addSubviews() {
        
    }
    
    private func configureConstraints() {
        
    }
    
    private func configureUI() {
        navigationItem.title = NSLocalizedString("App.BestCurrencyRates.NavigationItemTitle", comment: "")
    }
    
    private func bindings() {
        
    }
    
}
