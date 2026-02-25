
import SwiftUI

struct HistoryBadgeView: View {
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
                        .foregroundColor(.brown)
                        .offset(y: 10)
                    
                    Image(systemName: "scroll.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.brown)
                        .shadow(color: .brown.opacity(0.5), radius: 5)
                    
                    Image(systemName: "star.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.brown)
                        .offset(y: 10)
                }
                
                Image(systemName: "building.columns.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 80)
                    .foregroundColor(.brown)
                    .shadow(color: .brown.opacity(0.3), radius: 5, x: 0, y: 3)
                
                VStack(spacing: 2) {
                    Text("HISTORY")
                        .font(.system(size: 14, weight: .black, design: .monospaced))
                        .foregroundColor(.brown)
                        .padding(.top, 5)
                    
                    Text("SCHOLAR")
                        .font(.system(size: 10, weight: .bold, design: .monospaced))
                        .foregroundColor(.brown)
                        .tracking(1)
                }
            }
            .padding()
        }
        .frame(width: 200, height: 200)
    }
}
