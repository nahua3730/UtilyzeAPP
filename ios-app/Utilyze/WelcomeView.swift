import SwiftUI

struct WelcomeView: View {
    let onContinue: () -> Void

    var body: some View {
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

            Button(action: onContinue) {
                PrimaryButtonLabel(title: "Enable Alerts")
            }

            Text("Make sure you allow notifications on the next step.")
                .font(.footnote)
                .foregroundStyle(.gray)

            Spacer()
        }
        .padding(24)
    }
}
