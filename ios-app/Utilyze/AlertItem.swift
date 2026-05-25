import Foundation

struct AlertItem: Identifiable, Hashable, Decodable {
    let id: String
    let siteLabel: String
    let severity: String
    let title: String
    let bodyShort: String
    let bodyLong: String
    let timestamp: String
    let dataSummary: String
}
