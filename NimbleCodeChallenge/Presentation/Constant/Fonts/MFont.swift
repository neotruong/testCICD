import SwiftUI

struct MFont {
    
    enum FontWeight: String {
        case regular = "HelveticaNeue"
        case bold = "HelveticaNeue-Bold"
        case italic = "HelveticaNeue-Italic"
        case light = "HelveticaNeue-Light"
        case medium = "HelveticaNeue-Medium"
        case ultraLight = "HelveticaNeue-UltraLight"
        case thin = "HelveticaNeue-Thin"
        case condensedBlack = "HelveticaNeue-CondensedBlack"
        case condensedBold = "HelveticaNeue-CondensedBold"
    }

    static func customFont(_ weight: FontWeight = .regular, size: CGFloat) -> Font {
        return Font.custom(weight.rawValue, size: size)
    }
}
