import Foundation
import UIKit

struct Theme {

    enum Colors {
        case plus
        case minus
        case selected
        case unselected
        case navBar
        case navTint
        case titleTint

        var color: UIColor {
            let result: UIColor
            switch self {
            case .plus:
                result = #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)
            case .minus:
                result = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            case .selected, .navTint, .titleTint:
                result = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
            case .unselected:
                result = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            case .navBar:
                result = #colorLiteral(red: 0.5787474513, green: 0.3215198815, blue: 0, alpha: 1)
            }
            return result
        }
    }

    enum Fonts {
        case title

        var font: UIFont {
            let result: UIFont

            switch self {
            case .title:
                result = UIFont(name: "Copperplate-Bold", size: 18)!
            }

            return result
        }
    }
}
