
import SwiftUI

struct HintButton: View {
    var action: () -> Void
    var cost: Int = 5
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: "lightbulb.fill")
                    .font(.title3)
                
                if cost > 0 {
                    Text("-\(cost)")
                        .font(.system(size: 16, weight: .black, design: .rounded))
                } else {
                    Text("FREE")
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                }
            }
            .foregroundColor(.white)
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .background(cost > 0 ? Color.cryptoYellow : Color.cryptoGreen)
            .clipShape(Capsule())
            .shadow(color: (cost > 0 ? Color.cryptoYellow : Color.cryptoGreen).opacity(0.4), radius: 5, x: 0, y: 3)
            .overlay(
                Capsule()
                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
            )
        }
    }
}
