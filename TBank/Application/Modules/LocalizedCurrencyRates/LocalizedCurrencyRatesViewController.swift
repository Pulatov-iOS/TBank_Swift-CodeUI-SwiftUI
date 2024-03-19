import UIKit
import SnapKit

final class LocalizedCurrencyRatesViewController: UIViewController {
    
    // MARK: - Public Properties
    var viewModel: LocalizedCurrencyRatesViewModel!
    
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
        navigationItem.title = NSLocalizedString("App.LocalizedCurrencyRates.NavigationItemTitle", comment: "")
    }
    
    private func bindings() {
        
    }
    
}
