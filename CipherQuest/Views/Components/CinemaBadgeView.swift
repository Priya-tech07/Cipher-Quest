
import SwiftUI

struct CinemaBadgeView: View {
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
                        .foregroundColor(.cryptoPurple)
                        .offset(y: 10)
                    
                    Image(systemName: "film.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.cryptoPurple)
                        .shadow(color: .cryptoPurple.opacity(0.5), radius: 5)
                    
                    Image(systemName: "star.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.cryptoPurple)
                        .offset(y: 10)
                }
                
                Image(systemName: "popcorn.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 80)
                    .foregroundColor(.cryptoPurple)
                    .shadow(color: .cryptoPurple.opacity(0.3), radius: 5, x: 0, y: 3)
                
                VStack(spacing: 2) {
                    Text("CINEMA")
                        .font(.system(size: 14, weight: .black, design: .monospaced))
                        .foregroundColor(.cryptoPurple)
                        .padding(.top, 5)
                    
                    Text("BUFF")
                        .font(.system(size: 10, weight: .bold, design: .monospaced))
                        .foregroundColor(.cryptoPurple)
                        .tracking(1)
                }
            }
            .padding()
        }
        .frame(width: 200, height: 200)
    }
}
