
import SwiftUI

struct DeveloperBadgeView: View {
    var body: some View {
        ZStack {
            // White Blur Background
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.1))
                .background(.ultraThinMaterial)
                .cornerRadius(20)
                // Removed shadow to reduce brightness
            
            VStack(spacing: 15) {
                // Stars
                HStack(spacing: 15) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.cryptoYellow)
                        .offset(y: 10)
                    
                    Image(systemName: "star.fill")
                        .font(.system(size: 30))
                        .foregroundColor(.cryptoYellow)
                        .shadow(color: .orange.opacity(0.5), radius: 3) // Reduced shadow intensity
                    
                    Image(systemName: "star.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.cryptoYellow)
                        .offset(y: 10)
                }
                
                // Trophy Cup
                Image(systemName: "trophy.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 80)
                    .foregroundColor(.cryptoYellow)
                    .shadow(color: .orange.opacity(0.3), radius: 5, x: 0, y: 3) // Reduced shadow intensity
                    .overlay(
                        Image(systemName: "trophy")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 80, height: 80)
                            .foregroundColor(.white.opacity(0.2)) // Reduced overlay opacity
                    )
                
                // Text
                VStack(spacing: 2) {
                    Text("MASTER")
                        .font(.system(size: 14, weight: .black, design: .monospaced))
                        .foregroundColor(.cryptoYellow)
                        .padding(.top, 5)
                    
                    Text("DEVELOPER")
                        .font(.system(size: 10, weight: .bold, design: .monospaced))
                        .foregroundColor(.cryptoYellow) // Changed to Gold/Yellow
                        .tracking(1)
                }
            }
            .padding()
        }
        .frame(width: 200, height: 200)
    }
}
