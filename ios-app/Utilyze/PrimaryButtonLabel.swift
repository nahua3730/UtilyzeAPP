import SwiftUI

struct PrimaryButtonLabel: View {
    let title: String

    var body: some View {
        Text(title)
            .font(.headline)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Color.black)
            .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
