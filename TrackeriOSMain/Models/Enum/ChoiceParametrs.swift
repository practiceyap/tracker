import Foundation

enum ChoiceParametrs {
    case category
    case schedule
    
    var name: String {
        var name: String
        switch self {
        case .category:
            name = "Категория"
        case .schedule:
            name = "Расписание"
        }
        return name
    }
}
