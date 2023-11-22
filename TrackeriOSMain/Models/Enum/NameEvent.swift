import Foundation

enum NameEvent {
    case habit
    case irregularEvent
    
    var name: String {
        var name: String
        switch self {
        case .habit:
            name = "Привычка"
        case .irregularEvent:
            name = "Нерегулярное событие"
        }
        return name
    }
}
