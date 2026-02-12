
import SwiftUI

struct GrandMasterBadgeView: View {
    var body: some View {
        ZStack {
            // Radiant Background
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(colors: [.cryptoPurple.opacity(0.3), .clear]),
                        center: .center,
                        startRadius: 20,
                        endRadius: 100
                    )
                )
            
            // Gold Frame
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.white.opacity(0.1))
                .background(.ultraThinMaterial)
                .cornerRadius(25)
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(
                            LinearGradient(
                                colors: [.cryptoYellow, .cryptoPurple, .cryptoYellow],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 2
                        )
                )
            
            VStack(spacing: 8) {
                // Crown and Stars
                ZStack {
                    HStack(spacing: 40) {
                        Image(systemName: "star.fill")
                            .font(.caption)
                            .foregroundColor(.cryptoYellow)
                            .glow(color: .cryptoYellow, radius: 4)
                        
                        Image(systemName: "star.fill")
                            .font(.caption)
                            .foregroundColor(.cryptoYellow)
                            .glow(color: .cryptoYellow, radius: 4)
                    }
                    .offset(y: -15)
                    
                    Image(systemName: "crown.fill")
                        .font(.system(size: 30))
                        .foregroundColor(.cryptoYellow)
                        .shadow(color: .orange.opacity(0.6), radius: 5)
                }
                
                // Master Trophy
                ZStack {
                    Image(systemName: "trophy.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 90, height: 90)
                        .foregroundColor(.cryptoYellow)
                        .shadow(color: .cryptoPurple.opacity(0.5), radius: 10)
                    
                    Image(systemName: "trophy")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 60)
                        .foregroundColor(.white.opacity(0.4))
                }
                
                // Text
                VStack(spacing: 2) {
                    Text("GRAND")
                        .font(.system(size: 14, weight: .black, design: .monospaced))
                        .foregroundColor(.cryptoYellow)
                    
                    Text("MASTER")
                        .font(.system(size: 16, weight: .black, design: .monospaced))
                        .foregroundColor(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 2)
                        .background(Color.cryptoPurple)
                        .cornerRadius(5)
                }
                .padding(.top, 5)
            }
            .padding()
        }
        .frame(width: 200, height: 200)
    }
}
