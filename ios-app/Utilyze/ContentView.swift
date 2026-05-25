import SwiftUI
import UserNotifications
import UIKit

struct ContentView: View {
    private enum Screen {
        case welcome
        case onboarding
        case verify
        case notifications
    }

    @AppStorage("utilyze.isOnboarded") private var isOnboarded = false
    @AppStorage("utilyze.email") private var storedEmail = ""
    @AppStorage("utilyze.username") private var storedUsername = ""
    @AppStorage("utilyze.sessionToken") private var sessionToken = ""

    @State private var screen: Screen = .welcome
    @State private var email = ""
    @State private var username = ""
    @State private var verificationCode = ""
    @State private var requestId = ""
    @State private var errorMessage = ""
    @State private var alerts: [AlertItem] = []
    @State private var isSendingCode = false
    @State private var isVerifying = false
    @State private var isFinishingSetup = false
    @State private var isRefreshingAlerts = false
    @State private var isSendingTestAlert = false

    var body: some View {
        NavigationStack {
            Group {
                if isOnboarded {
                    AlertsFeedView(
                        alerts: alerts,
                        isRefreshingAlerts: isRefreshingAlerts,
                        isSendingTestAlert: isSendingTestAlert,
                        onSendTestAlert: {
                            Task { await sendTestAlert() }
                        },
                        onRefresh: {
                            await loadAlerts()
                        },
                        onClearDemoAlerts: {
                            Task { await clearDemoAlerts() }
                        },
                        onReset: resetOnboarding
                    )
                } else {
                    switch screen {
                    case .welcome:
                        WelcomeView {
                            screen = .onboarding
                        }
                    case .onboarding:
                        OnboardingView(
                            email: $email,
                            username: $username,
                            errorMessage: errorMessage,
                            isSendingCode: isSendingCode,
                            onSubmit: {
                                Task { await startEmailCode() }
                            }
                        )
                    case .verify:
                        VerifyCodeView(
                            verificationCode: $verificationCode,
                            errorMessage: errorMessage,
                            isVerifying: isVerifying,
                            onVerify: {
                                Task { await verifyEmailCode() }
                            }
                        )
                    case .notifications:
                        NotificationsPermissionView(
                            errorMessage: errorMessage,
                            isFinishingSetup: isFinishingSetup,
                            onAllow: {
                                Task { await finishOnboarding() }
                            },
                            onOpenSettings: openSettings
                        )
                    }
                }
            }
            .background(Color.white)
        }
        .tint(.black)
        .task {
            if !storedEmail.isEmpty && email.isEmpty {
                email = storedEmail
            }
            if !storedUsername.isEmpty && username.isEmpty {
                username = storedUsername
            }
            if isOnboarded, alerts.isEmpty, !storedUsername.isEmpty {
                await loadAlerts()
            }
        }
    }

    private func startEmailCode() async {
        do {
            isSendingCode = true
            errorMessage = ""
            requestId = try await APIClient.shared.startEmailCode(email: email)
            screen = .verify
        } catch {
            errorMessage = "Could not send verification code."
        }
        isSendingCode = false
    }

    private func verifyEmailCode() async {
        do {
            isVerifying = true
            errorMessage = ""

            let response = try await APIClient.shared.verifyEmailCode(
                email: email,
                requestId: requestId,
                code: verificationCode,
                username: username
            )

            storedEmail = email
            storedUsername = response.username
            sessionToken = response.sessionToken
            screen = .notifications
        } catch {
            errorMessage = "Could not verify the code."
        }
        isVerifying = false
    }

    private func finishOnboarding() async {
        isFinishingSetup = true
        errorMessage = ""

        do {
            let granted = try await UNUserNotificationCenter.current().requestAuthorization(
                options: [.alert, .badge, .sound]
            )

            if !granted {
                errorMessage = "Notifications are off. You can enable them in Settings anytime."
            }
        } catch {
            errorMessage = "Notification permissions could not be updated right now."
        }

        isOnboarded = true
        await loadAlerts()
        isFinishingSetup = false
    }

    private func loadAlerts() async {
        guard !storedUsername.isEmpty else { return }

        do {
            isRefreshingAlerts = true
            alerts = try await APIClient.shared.fetchAlerts(username: storedUsername)
        } catch {
            errorMessage = "Could not load alerts right now."
        }
        isRefreshingAlerts = false
    }

    private func sendTestAlert() async {
        isSendingTestAlert = true
        errorMessage = ""

        let settings = await UNUserNotificationCenter.current().notificationSettings()
        guard settings.authorizationStatus == .authorized || settings.authorizationStatus == .provisional else {
            errorMessage = "Notifications are not enabled for Utilyze yet. Tap Open Settings and turn on banners."
            isSendingTestAlert = false
            return
        }

        let content = UNMutableNotificationContent()
        content.title = "Utilyze Alert"
        content.body = "Demo alert: possible water leak detected at this property."
        content.sound = .default

        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        )

        do {
            _ = try await APIClient.shared.publishDemoAlert()
            try await UNUserNotificationCenter.current().add(request)
            await loadAlerts()
        } catch {
            errorMessage = "Could not schedule a local test alert."
        }

        isSendingTestAlert = false
    }

    private func clearDemoAlerts() async {
        do {
            isRefreshingAlerts = true
            alerts = try await APIClient.shared.resetDemoAlerts()
        } catch {
            errorMessage = "Could not reset demo alerts right now."
        }
        isRefreshingAlerts = false
    }

    private func openSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(url)
    }

    private func resetOnboarding() {
        isOnboarded = false
        storedEmail = ""
        storedUsername = ""
        sessionToken = ""
        email = ""
        username = ""
        verificationCode = ""
        requestId = ""
        alerts = []
        errorMessage = ""
        screen = .welcome
    }
}

#Preview {
    ContentView()
}
