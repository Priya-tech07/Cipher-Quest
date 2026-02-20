import SwiftUI

struct LaunchScreenView: View {
    @State private var loadingText = "INITIALIZING..."
    @State private var characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()_+"
    @State private var timer: Timer?
    @Binding var showLaunchScreen: Bool
    
    var body: some View {
        ZStack {
            Color.cryptoDarkBlue.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                // Secure Logo
                Image(systemName: "lock.shield.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .foregroundColor(.cryptoGreen)
                    .shadow(color: .cryptoGreen.opacity(0.5), radius: 20, x: 0, y: 0)
                
                // Title (Animated)
                Text(titleText)
                    .font(.system(size: 40, weight: .black, design: .monospaced))
                    .foregroundColor(.white)
                    .tracking(2)
                    .multilineTextAlignment(.center)
                
                // Status Text
                Text(statusText)
                    .font(.system(size: 14, weight: .bold, design: .monospaced))
                    .foregroundColor(.cryptoGreen)
                    .opacity(0.8)
            }
        }
        .onAppear {
            startDecryptionSequence()
        }
    }
    
    @State private var titleText = "XJ9#mK@L" // Initial scramble
    @State private var statusText = "INITIALIZING SECURITY PROTOCOLS..."
    
    // Simulates a decryption effect for the Title
    func startDecryptionSequence() {
        var cycleCount = 0
        let targetTitle = "CIPHER QUEST"
        let targetStatus = "SECURE CONNECTION ESTABLISHED"
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.08, repeats: true) { _ in
            if cycleCount < 25 {
                // Scramble Title
                let randomTitle = String((0..<targetTitle.count).map { _ in characters.randomElement()! })
                titleText = randomTitle
                
                // Flicker Status
                if cycleCount % 5 == 0 {
                    statusText = "DECRYPTING" + String(repeating: ".", count: (cycleCount / 5) % 4)
                }
                
                cycleCount += 1
            } else {
                // Reveal Title
                titleText = targetTitle
                statusText = targetStatus
                timer?.invalidate()
                
                // Transition to main app
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                    withAnimation(.easeOut(duration: 0.5)) {
                        showLaunchScreen = false
                    }
                }
            }
        }
    }
}
