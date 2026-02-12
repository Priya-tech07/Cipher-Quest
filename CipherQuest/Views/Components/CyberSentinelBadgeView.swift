
import SwiftUI

struct CyberSentinelBadgeView: View {
    var body: some View {
        ZStack {
            // Silver/Cyan Blur Background
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.1))
                .background(.ultraThinMaterial)
                .cornerRadius(20)
            
            VStack(spacing: 15) {
                // Secondary Stars
                HStack(spacing: 25) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.cyan.opacity(0.6))
                        .offset(y: 15)
                    
                    Image(systemName: "star.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.cyan.opacity(0.6))
                        .offset(y: 15)
                }
                
                // Main Star
                ZStack {
                    Circle()
                        .fill(Color.cyan.opacity(0.1))
                        .frame(width: 90, height: 90)
                    
                    Image(systemName: "star.shield.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 70, height: 70)
                        .foregroundColor(.cyan)
                        .shadow(color: .blue.opacity(0.4), radius: 10, x: 0, y: 5)
                }
                
                // Text
                VStack(spacing: 2) {
                    Text("CYBER")
                        .font(.system(size: 14, weight: .black, design: .monospaced))
                        .foregroundColor(.cyan)
                        .padding(.top, 5)
                    
                    Text("SENTINEL")
                        .font(.system(size: 10, weight: .bold, design: .monospaced))
                        .foregroundColor(.cyan) 
                        .tracking(2)
                }
            }
            .padding()
        }
        .frame(width: 200, height: 200)
    }
}
