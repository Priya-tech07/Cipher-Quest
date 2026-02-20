import SwiftUI

/// Standardised back button used across the entire app.
/// Renders as  "< Back"  with consistent size, position and colour.
struct BackButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 5) {
                Image(systemName: "chevron.left")
                Text("Back")
            }
            .font(.system(size: 16, weight: .bold, design: .monospaced))
            .foregroundColor(.cryptoGreen)
            .padding(10)
        }
    }
}
