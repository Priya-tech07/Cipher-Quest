
import SwiftUI

struct CoinView: View {
    var amount: Int
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: "centsign.circle.fill")
                .foregroundColor(.cryptoYellow)
                .font(.system(size: 16))
            Text("\(amount)")
                .font(.system(size: 16, weight: .bold, design: .monospaced))
                .foregroundColor(.cryptoText)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}
