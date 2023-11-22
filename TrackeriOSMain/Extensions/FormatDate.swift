import Foundation

final class FormatDate {
    static let shared = FormatDate()
    
    private lazy var dateFormatter: DateFormatter = {
        $0.dateFormat = "e"

        return $0
    }(DateFormatter())
    
    func createWeekDayInt(date: Date) -> Int {
        let weekDayString = dateFormatter.string(from: date)
        let deyWeek = NSString(string: weekDayString).intValue - 1
        return Int(deyWeek)
    }
}

