import UIKit.UIStackView

extension UIStackView {
    
    func addArrangedSubviews(with views: UIView...) {
        views.forEach { addArrangedSubview($0) }
    }
}
