
import SwiftUI

struct SecurityMasterBadgeView: View {
    var body: some View {
        ZStack {
            // Gold/Indigo Blur Background
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.1))
                .background(.ultraThinMaterial)
                .cornerRadius(20)
            
            VStack(spacing: 15) {
                // Security Ornaments
                HStack(spacing: 20) {
                    Image(systemName: "key.fill")
                        .font(.system(size: 18))
                        .foregroundColor(.cryptoPurple)
                        .rotationEffect(.degrees(-45))
                    
                    Image(systemName: "shield.checkered")
                        .font(.system(size: 24))
                        .foregroundColor(.cryptoPurple)
                    
                    Image(systemName: "key.fill")
                        .font(.system(size: 18))
                        .foregroundColor(.cryptoPurple)
                        .rotationEffect(.degrees(45))
                }
                
                // Silver Trophy
                ZStack {
                    Image(systemName: "trophy.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 85, height: 85)
                        .foregroundColor(.cryptoPink) // Silver-ish light blue
                        .shadow(color: .cryptoPurple.opacity(0.4), radius: 8, x: 0, y: 4)
                    
                    Circle()
                        .stroke(Color.cryptoPurple.opacity(0.3), lineWidth: 2)
                        .frame(width: 110, height: 110)
                }
                
                // Text
                VStack(spacing: 2) {
                    Text("SECURITY")
                        .font(.system(size: 14, weight: .black, design: .monospaced))
                        .foregroundColor(.cryptoPurple)
                        .padding(.top, 5)
                    
                    Text("MASTER")
                        .font(.system(size: 10, weight: .bold, design: .monospaced))
                        .foregroundColor(.cryptoPurple) 
                        .tracking(3)
                }
            }
            .padding()
        }
        .frame(width: 200, height: 200)
    }
}
