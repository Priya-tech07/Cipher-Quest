
import SwiftUI

struct SystemArchitectBadgeView: View {
    var body: some View {
        ZStack {
            // Platinum/Silver Blur Background
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.1))
                .background(.ultraThinMaterial)
                .cornerRadius(20)
            
            VStack(spacing: 15) {
                // Network Nodes
                HStack(spacing: 15) {
                    Image(systemName: "network")
                        .font(.system(size: 20))
                        .foregroundColor(.cyan)
                        .offset(y: 10)
                    
                    Image(systemName: "lock.shield.fill")
                        .font(.system(size: 30))
                        .foregroundColor(.cyan)
                        .shadow(color: .blue.opacity(0.5), radius: 3)
                    
                    Image(systemName: "network")
                        .font(.system(size: 20))
                        .foregroundColor(.cyan)
                        .offset(y: 10)
                }
                
                // Building Icon
                Image(systemName: "building.columns.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 80)
                    .foregroundColor(.cyan)
                    .shadow(color: .blue.opacity(0.3), radius: 5, x: 0, y: 3)
                    .overlay(
                        Image(systemName: "building.columns")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 80, height: 80)
                            .foregroundColor(.white.opacity(0.2))
                    )
                
                // Text
                VStack(spacing: 2) {
                    Text("SYSTEM")
                        .font(.system(size: 14, weight: .black, design: .monospaced))
                        .foregroundColor(.cyan)
                        .padding(.top, 5)
                    
                    Text("ARCHITECT")
                        .font(.system(size: 10, weight: .bold, design: .monospaced))
                        .foregroundColor(.cyan) 
                        .tracking(1)
                }
            }
            .padding()
        }
        .frame(width: 200, height: 200)
    }
}
