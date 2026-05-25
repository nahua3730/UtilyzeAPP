import Foundation

enum AlertTimeFormatter {
    static func displayText(for rawTimestamp: String) -> String {
        guard let date = ISO8601DateFormatter().date(from: rawTimestamp) else {
            return rawTimestamp
        }

        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}
