import UIKit.UIView

extension UIView {
    
    func addSubviews(with views: UIView...) {
        views.forEach { addSubview($0) }
    }
}
