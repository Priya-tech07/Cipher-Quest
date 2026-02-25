
import SwiftUI

struct CricketBadgeView: View {
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
                        .foregroundColor(.green)
                        .offset(y: 10)
                    
                    Image(systemName: "sportscourt.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.green)
                        .shadow(color: .green.opacity(0.5), radius: 5)
                    
                    Image(systemName: "star.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.green)
                        .offset(y: 10)
                }
                
                Image(systemName: "figure.cricket")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 80)
                    .foregroundColor(.green)
                    .shadow(color: .green.opacity(0.3), radius: 5, x: 0, y: 3)
                
                VStack(spacing: 2) {
                    Text("CRICKET")
                        .font(.system(size: 14, weight: .black, design: .monospaced))
                        .foregroundColor(.green)
                        .padding(.top, 5)
                    
                    Text("CHAMPION")
                        .font(.system(size: 10, weight: .bold, design: .monospaced))
                        .foregroundColor(.green)
                        .tracking(1)
                }
            }
            .padding()
        }
        .frame(width: 200, height: 200)
    }
}
