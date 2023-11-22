import Foundation

extension String {
    func firstCharOnly() -> String {
        return prefix(1).uppercased() + self.dropFirst()
    }
}
