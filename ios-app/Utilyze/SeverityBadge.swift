import SwiftUI

struct SeverityBadge: View {
    let severity: String

    private var backgroundColor: Color {
        switch severity.lowercased() {
        case "high":
            return Color.black
        case "medium":
            return Color.black.opacity(0.65)
        default:
            return Color.black.opacity(0.15)
        }
    }

    private var foregroundColor: Color {
        switch severity.lowercased() {
        case "low":
            return .black
        default:
            return .white
        }
    }

    var body: some View {
        Text(severity.uppercased())
            .font(.caption2.weight(.bold))
            .tracking(0.8)
            .foregroundStyle(foregroundColor)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(backgroundColor)
            .clipShape(Capsule())
    }
}
