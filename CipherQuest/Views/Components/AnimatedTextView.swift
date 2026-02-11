
import SwiftUI

struct AnimatedTextView: View {
    var text: String
    @State private var animatedText: String = ""
    
    var body: some View {
        Text(animatedText)
            .font(.system(.body, design: .monospaced))
            .onAppear {
                animateText()
            }
            .onChange(of: text) {
                animateText()
            }
    }
    
    private func animateText() {
        animatedText = text // Simplified for now, can perform typewriter effect
    }
}
