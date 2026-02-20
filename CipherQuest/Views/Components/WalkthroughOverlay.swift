
import SwiftUI

struct WalkthroughOverlay: View {
    @ObservedObject var viewModel: GameViewModel
    var steps: [String: CGRect]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Dimmed Background with Cutout
                ZStack {
                    Rectangle().fill(.ultraThinMaterial)
                    Color.black.opacity(0.6)
                }
                    .mask(
                        ZStack {
                            Rectangle().fill(Color.white)
                            
                            if let rect = currentTargetRect {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.black)
                                    .frame(width: rect.width + 16, height: rect.height + 16)
                                    .position(x: rect.midX, y: rect.midY)
                                    .blendMode(.destinationOut)
                            }
                        }
                        .compositingGroup()
                    )
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        viewModel.nextOnboardingStep()
                    }
                
                // Spotlight Border
                // Spotlight Border
                if let rect = currentTargetRect, shouldShowBorder {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.blue, lineWidth: 4)
                        .frame(width: rect.width + 16, height: rect.height + 16)
                        .position(x: rect.midX, y: rect.midY)
                        .allowsHitTesting(false)
                }
                
                // Tooltip
                if let rect = currentTargetRect {
                    TooltipView(
                        title: tooltipTitle,
                        message: tooltipMessage,
                        buttonTitle: isLastStep ? "START" : "NEXT",
                        action: { viewModel.nextOnboardingStep() }
                    )
                    .frame(width: 300)
                    .position(
                        x: geometry.size.width / 2, // Center horizontally
                        y: calculateTooltipY(targetRect: rect, in: geometry)
                    )
                } else {
                    // Centered Tooltip for steps without a specific target (e.g., Intro)
                    TooltipView(
                        title: tooltipTitle,
                        message: tooltipMessage,
                        buttonTitle: "NEXT",
                        action: { viewModel.nextOnboardingStep() }
                    )
                    .frame(width: 300)
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                }
            }
        }
    }
    
    private var currentTargetRect: CGRect? {
        // Map enum cases to highlight IDs
        let id: String
        switch viewModel.currentOnboardingStep {
        case .menuIntro: return nil 
        case .nameInput: return nil
        case .howToSolve: id = "how_to_solve_button"
        case .dailyChallenge: id = "daily_challenge_button"
        case .difficultyLevels: id = "difficulty_section"
        case .profileIntro: id = "profile_button"
        case .profileCoins: id = "profile_coins"
        case .profileLevel: id = "profile_level"
        case .profileXPStat: id = "profile_xp_stat"
        case .profileRiddles: id = "profile_riddles"
        case .profileBadges: id = "profile_badges"
        case .profileSettings: id = "profile_settings"
        case .profileXP: id = "profile_xp"
        case .gameIntro: id = "game_cipher_info"
        case .gameIntro: id = "game_cipher_info"
        case .gameHint: id = "game_hint_button"
        case .gameIndex: id = "game_index_button"
        case .gameHelp: id = "game_help_button"
        default: return nil
        }
        
        return steps[id]
    }
    
    private var tooltipTitle: String {
        switch viewModel.currentOnboardingStep {
        case .menuIntro: return "WELCOME AGENT"
        case .howToSolve: return "TRAINING MANUAL"
        case .dailyChallenge: return "DAILY ASSIGNMENT"
        case .difficultyLevels: return "CHOOSE YOUR MISSION"
        case .profileIntro: return "YOUR IDENTITY"
        case .profileCoins: return "AGENCY FUNDS"
        case .profileLevel: return "MISSION STATISTICS"
        case .profileXPStat: return "EXPERIENCE"
        case .profileRiddles: return "RIDDLE ARCHIVE"
        case .profileBadges: return "EARN BADGES"
        case .profileSettings: return "SYSTEM SETTINGS"
        case .profileXP: return "RANK UP"
        case .gameIntro: return "DECRYPTION TOOLS"
        case .gameIntro: return "DECRYPTION TOOLS"
        case .gameHint: return "NEED INTEL?"
        case .gameIndex: return "CIPHER INDEX"
        case .gameHelp: return "MISSION SUPPORT"
        default: return ""
        }
    }
    
    private var tooltipMessage: String {
        switch viewModel.currentOnboardingStep {
        case .menuIntro: return "You have been recruited to the Cipher Quest Agency. Let's get you briefed."
        case .howToSolve: return "Consult the guide here to understand different cipher techniques."
        case .dailyChallenge: return "Check back every day for a unique cipher mission and earn bonus XP."
        case .difficultyLevels: return "Start with Easy missions to learn the basics, then tackle Harder challenges as you gain clearance."
        case .profileIntro: return "Access your Agent Profile here to track progress and manage settings."
        case .profileCoins: return "Earn coins by solving ciphers. Use them to buy hints."
        case .profileLevel: return "Check your daily activity and how many levels you have completed."
        case .profileXPStat: return "Gain XP from successful missions to rank up."
        case .profileRiddles: return "Review all the riddles you've solved. Knowledge is power."
        case .profileBadges: return "Complete special tasks to earn commendation badges."
        case .profileSettings: return "Toggle Dark Mode or adjust other system preferences."
        case .profileXP: return "Gain XP to unlock new titles and clearance levels."
        case .gameIntro: return "Identify the cipher type here. This mission uses the Atbash Cipher - a simple substitution cipher."
        case .gameIntro: return "Identify the cipher type here. This mission uses the Atbash Cipher - a simple substitution cipher."
        case .gameHint: return "Use Agency Funds (coins) to reveal letters or get a clue if you're stuck."
        case .gameIndex: return "Access the reference chart to see A-Z mappings for the current cipher."
        case .gameHelp: return "Stuck? Get a detailed explanation of the current cipher's rules."
        default: return ""
        }
    }
    
    private var isLastStep: Bool {
        return viewModel.currentOnboardingStep == .gameHelp
    }
    
    private func calculateTooltipY(targetRect: CGRect, in geometry: GeometryProxy) -> CGFloat {
        // If target is in top half, show tooltip below. If in bottom half, show above.
        if targetRect.midY < geometry.size.height / 2 {
            return targetRect.maxY + 120 // Below
        } else {
            return targetRect.minY - 120 // Above
        }
    }
    
    private var shouldShowBorder: Bool {
        switch viewModel.currentOnboardingStep {
        case .menuIntro, .nameInput:
            return false
        default:
            return true
        }
    }
}

struct TooltipView: View {
    let title: String
    let message: String
    let buttonTitle: String
    let action: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.system(size: 16, weight: .black, design: .monospaced))
                .foregroundColor(.black)
            
            Text(message)
                .font(.system(size: 14, weight: .medium, design: .monospaced))
                .foregroundColor(.black)
                .fixedSize(horizontal: false, vertical: true)
            
            HStack {
                Spacer()
                Button(action: action) {
                    Text(buttonTitle)
                        .font(.system(size: 14, weight: .bold, design: .monospaced))
                        .foregroundColor(.white)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 20)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
            }
            .padding(.top, 5)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.blue, lineWidth: 3)
        )
    }
}
