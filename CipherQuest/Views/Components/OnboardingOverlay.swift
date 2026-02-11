
import SwiftUI

struct OnboardingOverlay: View {
    @ObservedObject var viewModel: GameViewModel
    @State private var currentStep = 0
    @State private var arrowOffset: CGFloat = 0
    @State private var agentNameInput: String = ""
    @State private var targetFrames: [HighlightArea: CGRect] = [:]
    
    private let steps = [
        OnboardingStep(
            title: "WELCOME AGENT",
            description: "You've been recruited to crack the world's most secure ciphers. Let's get you briefed.",
            icon: "shield.fill",
            color: .cryptoGreen
        ),
        OnboardingStep( // Index 1: Registration
            title: "IDENTITY REGISTRATION",
            description: "Enter your codename, Agent. This will be your identifier in the field.",
            icon: "person.text.rectangle.fill",
            color: .cryptoBlue,
            highlightArea: .center
        ),
        OnboardingStep(
            title: "YOUR IDENTITY",
            description: "Tap your agent identity here to view your stats and recovered badges.",
            icon: "person.crop.circle.fill",
            color: .cryptoGreen,
            highlightArea: .topRight
        ),
        OnboardingStep(
            title: "AGENT STATS",
            description: "Monitor your Coins, Mission progress, and XP right here.",
            icon: "bolt.fill",
            color: .orange,
            highlightArea: .profileStats,
            action: { vm in vm.isShowingProfile = true }
        ),
        OnboardingStep(
            title: "RECOVERED RIDDLES",
            description: "View all the secure messages you've successfully decrypted in the Riddles archive.",
            icon: "brain.head.profile",
            color: .cryptoPurple,
            highlightArea: .profileRiddles
        ),
        OnboardingStep(
            title: "FIELD GUIDES",
            description: "If you're ever stuck, use the 'How to Solve' section for tactical intelligence on any cipher.",
            icon: "questionmark.circle.fill",
            color: .cryptoPurple,
            highlightArea: .bottom,
            action: { vm in vm.isShowingProfile = false }
        ),
        OnboardingStep(
            title: "SELECT MISSION",
            description: "Choose your level of engagement. Easy for training, Hard for experienced cryptographers.",
            icon: "flag.fill",
            color: .cryptoBlue,
            highlightArea: .center
        ),
        OnboardingStep(
            title: "READY TO START?",
            description: "Your first daily challenge is waiting. Good luck, Agent.",
            icon: "lock.open.fill",
            color: .cryptoText
        )
    ]
    
    var body: some View {
        ZStack {
            // Background Dimmer
            Color.black.opacity(0.6)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture { /* Block background taps */ }
            
            // Highlight Cutout Logic
            GeometryReader { geo in
                if let highlight = steps[currentStep].highlightArea {
                    ZStack {
                        // Inverse mask effect
                        Color.black.opacity(0.5)
                            .mask(
                                HighlightMask(targetFrame: getTargetFrame(for: highlight, in: geo), fullscreen: geo.frame(in: .local))
                                    .fill(style: FillStyle(eoFill: true))
                            )
                        
                        // Animated Pointer (Skip for input step)
                        if currentStep != 1 {
                             PointerView(targetFrame: getTargetFrame(for: highlight, in: geo), color: steps[currentStep].color)
                        }
                    }
                }
            }
            .edgesIgnoringSafeArea(.all)
            .compositingGroup()
            
            // Instruction Card
            VStack(spacing: 0) {
                Spacer()
                
                VStack(spacing: 20) {
                    Image(systemName: steps[currentStep].icon)
                        .font(.system(size: 50))
                        .foregroundColor(steps[currentStep].color)
                        .scaleEffect(1.2)
                        .shadow(color: steps[currentStep].color.opacity(0.5), radius: 10, x: 0, y: 0)
                    
                    VStack(spacing: 12) {
                        Text(steps[currentStep].title)
                            .font(.system(size: 24, weight: .black, design: .monospaced))
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.5), radius: 2, x: 0, y: 2)
                        
                        Text(steps[currentStep].description)
                            .font(.system(size: 16, weight: .medium, design: .rounded))
                            .foregroundColor(.white.opacity(0.95))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 10)
                            .lineSpacing(4)
                            
                        // Input Field for User Name
                        if currentStep == 1 {
                            TextField("CODENAME", text: $agentNameInput)
                                .font(.system(size: 20, weight: .bold, design: .monospaced))
                                .multilineTextAlignment(.center)
                                .padding()
                                .background(Color.white.opacity(0.15))
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                )
                                .foregroundColor(.white)
                                .accentColor(steps[currentStep].color)
                                .padding(.top, 15)
                                .padding(.horizontal, 20)
                                .submitLabel(.done)
                        }
                    }
                    
                    HStack(spacing: 8) {
                        ForEach(0..<steps.count, id: \.self) { index in
                            Capsule()
                                .fill(index == currentStep ? steps[index].color : Color.white.opacity(0.2))
                                .frame(width: index == currentStep ? 24 : 8, height: 8)
                                .animation(.spring(), value: currentStep)
                        }
                    }
                    .padding(.top, 10)
                    
                    Button(action: nextStep) {
                        Text(currentStep == steps.count - 1 ? "BEGIN MISSION" : "NEXT")
                            .font(.system(size: 16, weight: .bold, design: .monospaced))
                            .foregroundColor(.white)
                            .padding(.vertical, 14)
                            .frame(maxWidth: .infinity)
                            .background(
                                // Disable next if name is empty on step 1
                                (currentStep == 1 && agentNameInput.trimmingCharacters(in: .whitespaces).isEmpty)
                                ? Color.gray
                                : steps[currentStep].color
                            )
                            .cornerRadius(14)
                            .shadow(color: steps[currentStep].color.opacity(0.4), radius: 10, x: 0, y: 5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 14)
                                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
                            )
                    }
                    .disabled(currentStep == 1 && agentNameInput.trimmingCharacters(in: .whitespaces).isEmpty)
                }
                .padding(30)
                .background(
                    ZStack {
                        VisualEffectBlur(blurStyle: .systemUltraThinMaterialDark)
                        Color.cryptoNavy.opacity(0.85)
                    }
                    .cornerRadius(30)
                    .shadow(color: .black.opacity(0.4), radius: 30, x: 0, y: 15)
                    .overlay(
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(LinearGradient(gradient: Gradient(colors: [Color.white.opacity(0.2), Color.white.opacity(0.05)]), startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 1)
                    )
                )
                .padding(.horizontal, 25)
                // Intelligent positioning to avoid covering the highlight
                .padding(.bottom, getCardBottomPadding())
                .padding(.top, getCardTopPadding())
            }
        }
        .animation(.spring(response: 0.5, dampingFraction: 0.75), value: currentStep)
        .onPreferenceChange(OnboardingPreferenceKey.self) { preferences in
            self.targetFrames = preferences
        }
    }
    
    // Helper to extract frame from preferences or fallback
    private func getTargetFrame(for area: HighlightArea, in geo: GeometryProxy) -> CGRect {
        if let frame = targetFrames[area] {
            // Convert global frame to local coordinate space of the overlay
             let localFrame = geo.frame(in: .global)
             return CGRect(
                 x: frame.minX - localFrame.minX,
                 y: frame.minY - localFrame.minY,
                 width: frame.width,
                 height: frame.height
             )
        }
        
        // Fallback for previews or missing frames
        let centered = CGRect(x: geo.size.width/2 - 100, y: geo.size.height/2 - 50, width: 200, height: 100)
        
        switch area {
        case .topRight:
            return CGRect(x: geo.size.width - 80, y: 50, width: 60, height: 60)
        case .bottom:
             return CGRect(x: geo.size.width/2 - 80, y: geo.size.height - 100, width: 160, height: 40)
        case .center:
            return centered
        case .profileStats:
            return CGRect(x: 20, y: 300, width: geo.size.width - 40, height: 150)
        case .profileRiddles:
             return CGRect(x: geo.size.width/2, y: 400, width: geo.size.width/2 - 20, height: 80)
        }
    }
    
    private func getCardBottomPadding() -> CGFloat {
        guard let highlight = steps[currentStep].highlightArea else { return 50 }
        if highlight == .bottom { return 200 }
        return 50
    }
    
     private func getCardTopPadding() -> CGFloat {
        guard let highlight = steps[currentStep].highlightArea else { return 0 }
        if highlight == .topRight { return 120 }
        return 0
    }
    
    private func nextStep() {
        // Save Name Logic
        if currentStep == 1 {
            if !agentNameInput.isEmpty {
                viewModel.updateAgentName(agentNameInput)
            }
        }
    
        if currentStep < steps.count - 1 {
            currentStep += 1
            // Execute step action if any
            steps[currentStep].action?(viewModel)
        } else {
            withAnimation {
                viewModel.completeOnboarding()
            }
        }
    }
}

// Custom Shape for Highlight Mask using dynamic rects
struct HighlightMask: Shape {
    let targetFrame: CGRect
    let fullscreen: CGRect
    
    func path(in rect: CGRect) -> Path {
        var path = Path(fullscreen) // Full screen box
        
        // Add padding/rounded corners to the cutout
        let padding: CGFloat = 8
        let cutoutRect = targetFrame.insetBy(dx: -padding, dy: -padding)
        let cutout = Path(roundedRect: cutoutRect, cornerRadius: 16)
        
        path.addPath(cutout)
        return path
    }
}

// Pointing Visual with pulsing effect
struct PointerView: View {
    let targetFrame: CGRect
    let color: Color
    @State private var animate = false
    
    var body: some View {
        ZStack {
            // Pulsing Ring
            Circle()
                .stroke(color.opacity(0.5), lineWidth: 4)
                .frame(width: 60, height: 60)
                .scaleEffect(animate ? 1.5 : 0.8)
                .opacity(animate ? 0 : 1)
                .position(x: targetFrame.midX, y: targetFrame.midY)
            
            Image(systemName: "arrow.down.circle.fill")
                .font(.system(size: 40, weight: .bold))
                .foregroundColor(color)
                .background(Circle().fill(Color.white).pad(2))
                .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 3)
                .offset(y: animate ? -15 : -5)
                .position(x: targetFrame.midX, y: targetFrame.minY - 40)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: false)) {
                animate = false // Reset
            }
            withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                animate = true
            }
        }
    }
}

// Helper for padding
extension View {
    func pad(_ amount: CGFloat) -> some View {
        self.padding(amount)
    }
}

struct OnboardingStep {
    let title: String
    let description: String
    let icon: String
    let color: Color
    var highlightArea: HighlightArea? = nil
    var action: ((GameViewModel) -> Void)? = nil
}

// Helper for Glassmorphism
struct VisualEffectBlur: UIViewRepresentable {
    var blurStyle: UIBlurEffect.Style
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: blurStyle))
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: blurStyle)
    }
}

#Preview {
    OnboardingOverlay(viewModel: GameViewModel())
}
