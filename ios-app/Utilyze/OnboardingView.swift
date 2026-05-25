import SwiftUI

struct OnboardingView: View {
    @Binding var email: String
    @Binding var username: String

    let errorMessage: String
    let isSendingCode: Bool
    let onSubmit: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Create Wallet")
                .font(.system(size: 30, weight: .bold))

            Text("Enter your email and Utilyze username to get started.")
                .foregroundStyle(.gray)

            Text("Demo mode: verification is currently stubbed while we wait on HandCash wallet onboarding access.")
                .font(.footnote)
                .foregroundStyle(.gray)

            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .font(.footnote)
                    .foregroundStyle(.red)
            }

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

            Button(action: onSubmit) {
                PrimaryButtonLabel(title: isSendingCode ? "Sending..." : "Send Verification Code")
            }
            .disabled(email.isEmpty || username.isEmpty || isSendingCode)
            .opacity(email.isEmpty || username.isEmpty || isSendingCode ? 0.5 : 1)
        }
        .padding(24)
    }
}
