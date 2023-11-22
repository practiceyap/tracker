import Foundation

enum Header {
    case color
    case emoji
    
    var name: String {
        var name: String
        switch self {
        case .color:
            name = "Цвет"
        case .emoji:
            name = "Emoji"
        }
        return name
    }
}

