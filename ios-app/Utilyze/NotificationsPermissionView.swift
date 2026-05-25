import SwiftUI

struct NotificationsPermissionView: View {
    let errorMessage: String
    let isFinishingSetup: Bool
    let onAllow: () -> Void
    let onOpenSettings: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Spacer()

            Text("Allow Notifications")
                .font(.system(size: 30, weight: .bold))

            Text("Utilyze uses notifications to send leak and safety alerts to your lock screen.")
                .foregroundStyle(.gray)

            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .font(.footnote)
                    .foregroundStyle(.red)
            }

            Button(action: onAllow) {
                PrimaryButtonLabel(title: isFinishingSetup ? "Finishing..." : "Allow Notifications")
            }
            .disabled(isFinishingSetup)
            .opacity(isFinishingSetup ? 0.5 : 1)

            Button(action: onOpenSettings) {
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
}
