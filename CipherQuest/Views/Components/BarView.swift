
import SwiftUI

struct BarView: View {
    let label: String
    let value: Int
    let color: Color
    let maxVal: Int
    
    @State private var showBar = false
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("\(value)")
                .font(.system(size: 14, weight: .bold, design: .monospaced))
                .foregroundColor(.white)
                .padding(.bottom, 5)
                .opacity(showBar ? 1 : 0)
                .animation(.easeOut(duration: 0.5).delay(0.3), value: showBar)
            
            GeometryReader { geometry in
                VStack {
                    Spacer()
                    RoundedRectangle(cornerRadius: 5)
                        .fill(color)
                        .frame(height: showBar ? (maxVal > 0 ? CGFloat(value) / CGFloat(maxVal) * geometry.size.height : 0) : 0)
                        .animation(.spring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.5), value: showBar)
                }
            }
            .frame(height: 150)
            
            Text(label)
                .font(.system(size: 10, weight: .bold, design: .monospaced))
                .foregroundColor(.cryptoSubtext)
                .padding(.top, 10)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                showBar = true
            }
        }
    }
}
