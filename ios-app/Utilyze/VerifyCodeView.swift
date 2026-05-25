import SwiftUI

struct VerifyCodeView: View {
    @Binding var verificationCode: String

    let errorMessage: String
    let isVerifying: Bool
    let onVerify: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Verify")
                .font(.system(size: 30, weight: .bold))

            Text("Enter the verification code sent to your email.")
                .foregroundStyle(.gray)

            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .font(.footnote)
                    .foregroundStyle(.red)
            }

            Text("Verification Code")
                .font(.subheadline.weight(.semibold))

            TextField("123456", text: $verificationCode)
                .keyboardType(.numberPad)
                .padding()
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 14))

            Spacer()

            Button(action: onVerify) {
                PrimaryButtonLabel(title: isVerifying ? "Verifying..." : "Verify")
            }
            .disabled(verificationCode.isEmpty || isVerifying)
            .opacity(verificationCode.isEmpty || isVerifying ? 0.5 : 1)
        }
        .padding(24)
    }
}
