import SwiftUI

struct LaunchScreenView: View {
    @Binding var showLaunchScreen: Bool
    
    var body: some View {
        ZStack {
            // Solid white background
            Color.white.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 40) {
                // Centered App Logo
                Image("AppLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 180, height: 180)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .scaleEffect(logoScale)
                    .opacity(logoOpacity)
                
                // Animated Title Text
                Text(displayedTitle)
                    .font(.system(size: 32, weight: .black, design: .monospaced))
                    .foregroundColor(Color(hex: "102A43"))
                    .tracking(4)
                    .opacity(textOpacity)
            }
        }
        .onAppear {
            startAnimationSequence()
        }
    }
    
    @State private var logoScale: CGFloat = 0.5
    @State private var logoOpacity: Double = 0.0
    @State private var textOpacity: Double = 0.0
    @State private var displayedTitle: String = "XJ9#mK Q#P7T"
    
    private let characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()_+"
    
    func startAnimationSequence() {
        // 1. Logo & Encrypted Text Pop Up Together
        withAnimation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0)) {
            logoScale = 1.0
            logoOpacity = 1.0
            textOpacity = 1.0
        }
        
        
        // 2. Decrypt "CIPHER" (Short delay for impact)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            scrambleAndReveal(target: "CIPHER", startPos: 0) {
                // 3. Decrypt "QUEST" (Immediate follow-up)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    scrambleAndReveal(target: "QUEST", startPos: 7) {
                        // 4. Final Transition
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                            withAnimation(.easeOut(duration: 0.5)) {
                                showLaunchScreen = false
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    func scrambleAndReveal(target: String, startPos: Int, completion: @escaping () -> Void) {
        var cycleCount = 0
        let totalCycles = 6 // Faster cycles for snappier feel
        
        Timer.scheduledTimer(withTimeInterval: 0.06, repeats: true) { timer in
            if cycleCount < totalCycles {
                var currentChars = Array(displayedTitle)
                for i in 0..<target.count {
                    if startPos + i < currentChars.count {
                        currentChars[startPos + i] = characters.randomElement()!
                    }
                }
                displayedTitle = String(currentChars)
                cycleCount += 1
            } else {
                var currentChars = Array(displayedTitle)
                let targetChars = Array(target)
                for i in 0..<target.count {
                    if startPos + i < currentChars.count {
                        currentChars[startPos + i] = targetChars[i]
                    }
                }
                displayedTitle = String(currentChars)
                timer.invalidate()
                completion()
            }
        }
    }
}
