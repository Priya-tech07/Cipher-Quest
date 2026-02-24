import SwiftUI

struct LaunchScreenView: View {
    @Binding var showLaunchScreen: Bool
    
    var body: some View {
        ZStack {
            // Solid white background as requested
            Color.white.edgesIgnoringSafeArea(.all)
            
            // Cyber scanline effect
            GeometryReader { geo in
                VStack(spacing: 0) {
                    ForEach(0..<Int(geo.size.height / 4), id: \.self) { _ in
                        Rectangle()
                            .fill(Color.black.opacity(0.03))
                            .frame(height: 1)
                        Spacer(minLength: 3)
                    }
                }
            }
            .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 40) {
                // Centered App Logo with pop-up & chromatic aberration
                ZStack {
                    // RGB Shift layers for game feel
                    Image("AppLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 180, height: 180)
                        .clipShape(RoundedRectangle(cornerRadius: 36))
                        .offset(x: glitchOffset, y: 0)
                        .colorMultiply(.red.opacity(glitchOpacity))
                    
                    Image("AppLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 180, height: 180)
                        .clipShape(RoundedRectangle(cornerRadius: 36))
                        .offset(x: -glitchOffset, y: 0)
                        .colorMultiply(.cyan.opacity(glitchOpacity))
                    
                    Image("AppLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 180, height: 180)
                        .clipShape(RoundedRectangle(cornerRadius: 36))
                }
                .scaleEffect(logoScale)
                .opacity(logoOpacity)
                
                // Animated Title Text with glitchy flicker
                Text(displayedTitle)
                    .font(.system(size: 32, weight: .black, design: .monospaced))
                    .foregroundColor(Color(hex: "102A43")) // Deep navy for visibility on white
                    .tracking(4)
                    .opacity(textOpacity)
                    .offset(x: textGlitchOffset)
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
    @State private var glitchOffset: CGFloat = 0
    @State private var textGlitchOffset: CGFloat = 0
    @State private var glitchOpacity: Double = 0
    
    private let characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()_+"
    
    func startAnimationSequence() {
        // 1. Logo & Encrypted Text Pop Up Together
        withAnimation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0)) {
            logoScale = 1.0
            logoOpacity = 1.0
            textOpacity = 1.0
        }
        
        // Start background glitch loop
        startGlitchLoop()
        
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
    
    func startGlitchLoop() {
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            if Int.random(in: 0...20) > 18 {
                glitchOffset = CGFloat.random(in: -4...4)
                textGlitchOffset = CGFloat.random(in: -2...2)
                glitchOpacity = 0.5
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                    glitchOffset = 0
                    textGlitchOffset = 0
                    glitchOpacity = 0
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
