
import SwiftUI

struct GeographyBadgeView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.1))
                .background(.ultraThinMaterial)
                .cornerRadius(20)
            
            VStack(spacing: 15) {
                HStack(spacing: 15) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.blue)
                        .offset(y: 10)
                    
                    Image(systemName: "globe.americas.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.blue)
                        .shadow(color: .blue.opacity(0.5), radius: 5)
                    
                    Image(systemName: "star.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.blue)
                        .offset(y: 10)
                }
                
                Image(systemName: "map.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 80)
                    .foregroundColor(.blue)
                    .shadow(color: .blue.opacity(0.3), radius: 5, x: 0, y: 3)
                
                VStack(spacing: 2) {
                    Text("GEOGRAPHY")
                        .font(.system(size: 14, weight: .black, design: .monospaced))
                        .foregroundColor(.blue)
                        .padding(.top, 5)
                    
                    Text("EXPLORER")
                        .font(.system(size: 10, weight: .bold, design: .monospaced))
                        .foregroundColor(.blue)
                        .tracking(1)
                }
            }
            .padding()
        }
        .frame(width: 200, height: 200)
    }
}
