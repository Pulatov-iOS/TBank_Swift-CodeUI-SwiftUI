import UIKit.UIFont

//MARK: - Enum with Manrope font's styles to use to fallowing extension UIFont class

enum ManropeFontStyle: String {
    case extraBold = "Manrope-ExtraBold"
    case bold = "Manrope-Bold"
    case semiBold = "Manrope-SemiBold"
    case medium = "Manrope-Medium"
    case regular = "Manrope-Regular"
    case light = "Manrope-Light"
    case extraLight = "Manrope-ExtraLight"
}


//MARK: - Extenion to add new system font to UIFont class

extension UIFont {
    
    static func manrope(ofSize size: CGFloat, style: ManropeFontStyle) -> UIFont {
        return UIFont(name: style.rawValue, size: size) ?? .systemFont(ofSize: size)
    }
}
