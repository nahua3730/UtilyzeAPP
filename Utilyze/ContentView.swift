import SwiftUI

struct AlertItem: Identifiable, Hashable {
    let id = UUID()
    let severity: String
    let title: String
    let bodyShort: String
    let bodyLong: String
    let timestamp: String
    let dataSummary: String
}

struct ContentView: View {
    private enum Screen {
        case welcome
        case onboarding
        case verify
        case notifications
        case feed
    }

    @State private var screen: Screen = .welcome
    @State private var email = ""
    @State private var username = ""
    @State private var verificationCode = ""
    @State private var alerts: [AlertItem] = [
        AlertItem(
            severity: "High",
            title: "Possible water leak",
            bodyShort: "Continuous flow detected for 45 minutes",
            bodyLong: "Utilyze detected unusual continuous water usage at this property. Check nearby fixtures, supply lines, and shutoff access as soon as possible.",
            timestamp: "Today at 3:42 PM",
            dataSummary: "{\n  \"rule\": \"continuous_flow\",\n  \"duration_minutes\": 45\n}"
        ),
        AlertItem(
            severity: "Medium",
            title: "Gas usage anomaly",
            bodyShort: "Usage pattern changed from the normal baseline",
            bodyLong: "Utilyze flagged a gas usage pattern that differs from the recent baseline. Review the site to confirm whether the activity is expected.",
            timestamp: "Today at 1:18 PM",
            dataSummary: "{\n  \"rule\": \"baseline_shift\",\n  \"utility\": \"gas\"\n}"
        )
    ]

    var body: some View {
        NavigationStack {
            Group {
                switch screen {
                case .welcome:
                    welcomeView
                case .onboarding:
                    onboardingView
                case .verify:
                    verifyView
                case .notifications:
                    notificationsView
                case .feed:
                    alertsFeedView
                }
            }
            .background(Color.white)
        }
        .tint(.black)
    }

    private var welcomeView: some View {
        VStack(spacing: 24) {
            Spacer()

            VStack(spacing: 12) {
                Text("Utilyze App")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundStyle(.black)

                Text("The Next Evolution of Utility Data")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.black)

                Text("🔥 💧 ⚡️")
                    .font(.title)
            }

            Text("Enable mobile alerts for gas and water risks.")
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundStyle(.black.opacity(0.75))
                .padding(.horizontal, 24)

            Button {
                screen = .onboarding
            } label: {
                primaryButtonLabel("Enable Alerts")
            }

            Text("Make sure you allow notifications on the next step.")
                .font(.footnote)
                .foregroundStyle(.gray)

            Spacer()
        }
        .padding(24)
    }

    private var onboardingView: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Create Wallet")
                .font(.system(size: 30, weight: .bold))

            Text("Enter your email and Utilyze username to get started.")
                .foregroundStyle(.gray)

            Group {
                Text("Email")
                    .font(.subheadline.weight(.semibold))
                TextField("user@example.com", text: $email)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)
                    .autocorrectionDisabled()
                    .padding()
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 14))

                Text("Utilyze Username")
                    .font(.subheadline.weight(.semibold))
                TextField("utilyze_username", text: $username)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .padding()
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }

            Spacer()

            Button {
                screen = .verify
            } label: {
                primaryButtonLabel("Send Verification Code")
            }
            .disabled(email.isEmpty || username.isEmpty)
            .opacity(email.isEmpty || username.isEmpty ? 0.5 : 1)
        }
        .padding(24)
    }

    private var verifyView: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Verify")
                .font(.system(size: 30, weight: .bold))

            Text("Enter the verification code sent to your email.")
                .foregroundStyle(.gray)

            Text("Verification Code")
                .font(.subheadline.weight(.semibold))

            TextField("123456", text: $verificationCode)
                .keyboardType(.numberPad)
                .padding()
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 14))

            Spacer()

            Button {
                screen = .notifications
            } label: {
                primaryButtonLabel("Verify")
            }
            .disabled(verificationCode.isEmpty)
            .opacity(verificationCode.isEmpty ? 0.5 : 1)
        }
        .padding(24)
    }

    private var notificationsView: some View {
        VStack(alignment: .leading, spacing: 20) {
            Spacer()

            Text("Allow Notifications")
                .font(.system(size: 30, weight: .bold))

            Text("Utilyze uses notifications to send leak and safety alerts to your lock screen.")
                .foregroundStyle(.gray)

            Button {
                screen = .feed
            } label: {
                primaryButtonLabel("Allow Notifications")
            }

            Button {
            } label: {
                Text("Open Settings")
                    .font(.headline)
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.black.opacity(0.12), lineWidth: 1)
                    )
            }

            Spacer()
        }
        .padding(24)
    }

    private var alertsFeedView: some View {
        List {
            Section {
                if alerts.isEmpty {
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
                    ForEach(alerts) { alert in
                        NavigationLink(value: alert) {
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text(alert.title)
                                        .font(.headline)
                                        .foregroundStyle(.black)
                                    Spacer()
                                    Text(alert.severity)
                                        .font(.caption.weight(.semibold))
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 6)
                                        .background(Color.black.opacity(0.08))
                                        .clipShape(Capsule())
                                }

                                Text(alert.bodyShort)
                                    .font(.subheadline)
                                    .foregroundStyle(.gray)

                                Text(alert.timestamp)
                                    .font(.caption)
                                    .foregroundStyle(.gray)
                            }
                            .padding(.vertical, 8)
                        }
                        .listRowBackground(Color.white)
                    }
                }
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color.white)
        .navigationTitle("Alerts")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(for: AlertItem.self) { alert in
            AlertDetailView(alert: alert)
        }
    }

    private func primaryButtonLabel(_ title: String) -> some View {
        Text(title)
            .font(.headline)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Color.black)
            .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

private struct AlertDetailView: View {
    let alert: AlertItem

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text(alert.title)
                    .font(.system(size: 30, weight: .bold))

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
    }
}

#Preview {
    ContentView()
}
