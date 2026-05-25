import SwiftUI

struct AlertDetailView: View {
    let alert: AlertItem

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 12) {
                    SeverityBadge(severity: alert.severity)

                    Text(alert.title)
                        .font(.system(size: 30, weight: .bold))

                    Text(alert.siteLabel)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.black.opacity(0.7))
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Summary")
                        .font(.headline)
                    Text(alert.bodyShort)
                        .foregroundStyle(.gray)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Details")
                        .font(.headline)
                    Text(alert.bodyLong)
                        .foregroundStyle(.black)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Timestamp")
                        .font(.headline)
                    Text(alert.timestamp)
                        .foregroundStyle(.gray)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Data")
                        .font(.headline)
                    Text(alert.dataSummary)
                        .font(.system(.footnote, design: .monospaced))
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
            }
            .padding(24)
        }
        .background(Color.white)
        .navigationBarTitleDisplayMode(.inline)
    }
}
