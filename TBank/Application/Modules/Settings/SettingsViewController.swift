import UIKit
import SnapKit

final class SettingsViewController: UIViewController {
    
    // MARK: - Public Properties
    var viewModel: SettingsViewModel!

    
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
        view.backgroundColor = .yellow
    }
    
    private func bindings() {
        
    }
    
}
