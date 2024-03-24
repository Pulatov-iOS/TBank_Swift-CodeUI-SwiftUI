import UIKit
import SnapKit

final class BankLocatorMapViewController: UIViewController {
    
    // MARK: - Public Properties
    var viewModel: BankLocatorMapViewModel!
    
    // MARK: - UI Properties
    
    let delete = UIButton() // Удалить по окончанию!!!🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨
    
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
        view.addSubview(delete)
    }
    
    private func configureConstraints() {
        delete.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func configureUI() {
        view.backgroundColor = .white
    }
    
    private func bindings() {
        delete.setTitle("dsde", for: .normal)
        delete.setTitleColor(.black, for: .normal)
        delete.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc func buttonTapped() {
        viewModel.exchangeRatesButtonTapped()
    }
}
