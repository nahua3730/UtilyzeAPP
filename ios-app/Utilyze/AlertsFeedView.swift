import SwiftUI

struct AlertsFeedView: View {
    enum Filter: String, CaseIterable {
        case all = "All"
        case high = "High"
        case medium = "Medium"
    }

    let alerts: [AlertItem]
    let isRefreshingAlerts: Bool
    let isSendingTestAlert: Bool
    let lastUpdatedText: String
    let onSendTestAlert: () -> Void
    let onRefresh: () async -> Void
    let onClearDemoAlerts: () -> Void
    let onReset: () -> Void

    @State private var selectedFilter: Filter = .all

    private var filteredAlerts: [AlertItem] {
        switch selectedFilter {
        case .all:
            return alerts
        case .high:
            return alerts.filter { $0.severity.caseInsensitiveCompare("High") == .orderedSame }
        case .medium:
            return alerts.filter { $0.severity.caseInsensitiveCompare("Medium") == .orderedSame }
        }
    }

    var body: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Demo Mode")
                        .font(.headline)
                    Text("Wallet onboarding and email verification are temporarily stubbed while we wait on HandCash. You can still test Utilyze alerts and notification UX right now.")
                        .font(.subheadline)
                        .foregroundStyle(.gray)

                    Button(action: onSendTestAlert) {
                        Text(isSendingTestAlert ? "Sending Test Alert..." : "Send Test Alert")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(Color.black)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    .disabled(isSendingTestAlert)
                    .opacity(isSendingTestAlert ? 0.5 : 1)
                }
                .padding(.vertical, 8)
            }
            .listRowBackground(Color.white)

            Section {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("System Status")
                            .font(.headline)
                        Spacer()
                        Text(lastUpdatedText)
                            .font(.caption)
                            .foregroundStyle(.gray)
                    }

                    Text("Local notifications and backend demo alerts are active.")
                        .font(.subheadline)
                        .foregroundStyle(.gray)

                    Picker("Filter", selection: $selectedFilter) {
                        ForEach(Filter.allCases, id: \.self) { filter in
                            Text(filter.rawValue).tag(filter)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                .padding(.vertical, 8)
            }
            .listRowBackground(Color.white)

            Section {
                if filteredAlerts.isEmpty {
                    VStack(spacing: 10) {
                        Text("No alerts yet")
                            .font(.headline)
                        Text("When Utilyze detects an issue, it will show up here.")
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 32)
                    .listRowBackground(Color.white)
                } else {
                    ForEach(filteredAlerts) { alert in
                        NavigationLink(value: alert) {
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 6) {
                                        Text(alert.title)
                                            .font(.headline)
                                            .foregroundStyle(.black)

                                        Text(alert.timestamp)
                                            .font(.caption)
                                            .foregroundStyle(.gray)
                                    }

                                    Spacer()
                                    SeverityBadge(severity: alert.severity)
                                }

                                Text(alert.bodyShort)
                                    .font(.subheadline)
                                    .foregroundStyle(.gray)
                                    .multilineTextAlignment(.leading)
                            }
                            .padding(.vertical, 8)
                        }
                        .listRowBackground(Color.white)
                    }
                }
            }
        }
        .overlay(alignment: .bottom) {
            if isRefreshingAlerts {
                ProgressView()
                    .padding(.bottom, 12)
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color.white)
        .navigationTitle("Alerts")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(for: AlertItem.self) { alert in
            AlertDetailView(alert: alert)
        }
        .refreshable {
            await onRefresh()
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Clear Alerts", action: onClearDemoAlerts)
                    .foregroundStyle(.black)
            }

            ToolbarItem(placement: .topBarTrailing) {
                Button("Reset", action: onReset)
                    .foregroundStyle(.black)
            }
        }
    }
}
