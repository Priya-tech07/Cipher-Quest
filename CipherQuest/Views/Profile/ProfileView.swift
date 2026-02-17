
import SwiftUI

struct ProfileView: View {
    @ObservedObject var viewModel: GameViewModel
    @EnvironmentObject var themeManager: ThemeManager
    var onDismiss: () -> Void
    
    @State private var isEditingName = false
    @State private var editingName = ""
    
    var body: some View {
        VStack(spacing: 0) {

            
            // Header
            HStack {
                Button(action: onDismiss) {
                    HStack(spacing: 5) {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                    .font(.system(size: 16, weight: .bold, design: .monospaced))
                    .foregroundColor(.cryptoGreen)
                    .padding(10)
                }
                
                Spacer()
                
                Text("AGENT PROFILE")
                    .font(.system(size: 18, weight: .black, design: .monospaced))
                    .foregroundColor(.cryptoText)
                
                Spacer()
                
                // Hidden placeholder for alignment
                Button(action: {}) {
                    HStack(spacing: 5) {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                    .font(.system(size: 16, weight: .bold, design: .monospaced))
                    .padding(10)
                }
                .opacity(0)
            }
            .padding(.horizontal)
            .padding(.bottom, 15)
            .padding(.top, 50)
            .background(Color.cryptoDarkBlue.edgesIgnoringSafeArea(.top))
            
            ScrollView {
                ScrollViewReader { proxy in
                    VStack(spacing: 25) {
                    // Avatar Section
                    Image(systemName: "person.crop.circle.fill")
                        .font(.system(size: 100))
                        .foregroundColor(.cryptoGreen)
                        .shadow(color: .cryptoGreen.opacity(0.2), radius: 10, x: 0, y: 5)
                    
                    .padding(.top, 10)
                    
                    // Name Section
                    VStack(spacing: 10) {
                        if isEditingName {
                            HStack(spacing: 0) {
                                // Invisible balance icon
                                Image(systemName: "pencil.circle.fill")
                                    .font(.title2)
                                    .opacity(0)
                                    .padding(.trailing, 12)
                                
                                TextField("AGENT NAME", text: $editingName)
                                    .font(.system(size: 24, weight: .black, design: .monospaced))
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.cryptoText)
                                    .accentColor(.cryptoGreen)
                                    .submitLabel(.done)
                                    .onSubmit(saveName)
                                
                                Button(action: saveName) {
                                    Image(systemName: "pencil.circle.fill")
                                        .foregroundColor(.cryptoGreen)
                                        .font(.title2)
                                }
                                .padding(.leading, 12)
                            }
                            .padding(.horizontal, 20)
                        } else {
                            HStack(spacing: 0) {
                                // Invisible balance icon
                                Image(systemName: "pencil.circle.fill")
                                    .font(.title2)
                                    .opacity(0)
                                    .padding(.trailing, 12)
                                
                                Text(viewModel.playerStats.agentName)
                                    .font(.system(size: 28, weight: .black, design: .monospaced))
                                    .foregroundColor(.cryptoGreen)
                                    .multilineTextAlignment(.center)
                                    .shadow(color: .cryptoGreen.opacity(0.3), radius: 5)
                                
                                Button(action: {
                                    editingName = viewModel.playerStats.agentName
                                    isEditingName = true
                                }) {
                                    Image(systemName: "pencil.circle.fill")
                                        .foregroundColor(.cryptoGreen)
                                        .font(.title2)
                                }
                                .padding(.leading, 12)
                            }
                        }
                        
                        Text("CODENAME")
                            .font(.system(size: 10, weight: .bold, design: .monospaced))
                            .foregroundColor(.cryptoSubtext)
                    }
                    .padding(.top, -10)
                    
                    // Settings Section
                    VStack(alignment: .leading, spacing: 15) {
                        Text("SYSTEM SETTINGS")
                            .font(.system(size: 14, weight: .black, design: .monospaced))
                            .foregroundColor(.cryptoText)
                            .padding(.horizontal)
                        
                        Toggle(isOn: $themeManager.isDarkMode) {
                            HStack {
                                Image(systemName: themeManager.isDarkMode ? "sun.max.fill" : "moon.fill")
                                    .foregroundColor(themeManager.isDarkMode ? .yellow : .cryptoPurple)
                                Text(themeManager.isDarkMode ? "LIGHT MODE" : "DARK MODE")
                                    .font(.system(size: 16, weight: .bold, design: .monospaced))
                                    .foregroundColor(.cryptoText)
                            }
                        }
                        .padding()
                        .background(Color.cryptoSurface.opacity(0.3))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.cryptoSubtext.opacity(0.1), lineWidth: 1)
                        )
                        .walkthroughHighlight(id: "profile_settings", enabled: viewModel.isOnboarding)
                        .padding(.horizontal)
                    }
                    .padding(.bottom, 10)
                    .id("settings_section")
                    
                    // Progress Section
                    VStack(alignment: .leading, spacing: 10) {
                        let currentXP = viewModel.playerStats.experience
                        let riddleMilestones = [500, 1000, 2000, 3000]
                        let nextMilestone = riddleMilestones.first(where: { $0 > currentXP }) ?? 3000
                        
                        // Fix for user confusion: Calculate progress as a percentage of the total milestone, not just the current level
                        let progress = Double(currentXP) / Double(nextMilestone)
                        let isAllMaxed = currentXP >= 3000
                        
                        let nextUnlockName: String = {
                            switch nextMilestone {
                            case 500: return "SYSTEM ARCHITECT"
                            case 1000: return "CYBER SENTINEL"
                            case 2000: return "SECURITY MASTER"
                            case 3000: return currentXP >= 3000 ? "GRAND MASTER" : "GRAND MASTER"
                            default: return ""
                            }
                        }()

                        // Progress Section (Circular Redesign)
                        HStack(alignment: .center, spacing: 20) {
                            // Left: Text Info
                            VStack(alignment: .leading, spacing: 8) {
                                Text(isAllMaxed ? "FULL SYSTEM CLEARANCE" : "NEXT CLEARANCE:")
                                    .font(.system(size: 10, weight: .bold, design: .monospaced))
                                    .foregroundColor(.cryptoSubtext)
                                
                                Text(nextUnlockName)
                                    .font(.system(size: 16, weight: .black, design: .monospaced))
                                    .foregroundColor(.cryptoText)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.8)
                                
                                Text(isAllMaxed ? "MAXED" : "\(nextMilestone - currentXP) XP TO UNLOCK")
                                    .font(.system(size: 10, weight: .bold, design: .monospaced))
                                    .foregroundColor(.cryptoGreen)
                                
                                Text(isAllMaxed ? "" : "\(currentXP) / \(nextMilestone) XP")
                                    .font(.system(size: 12, design: .monospaced))
                                    .foregroundColor(.cryptoPurple)
                            }
                            
                            Spacer()
                            
                            // Right: Circular Progress
                            ZStack {
                                // Background Track
                                Circle()
                                    .stroke(Color.cryptoLightNavy, lineWidth: 8)
                                    .frame(width: 60, height: 60)
                                
                                // Progress
                                Circle()
                                    .trim(from: 0.0, to: CGFloat(isAllMaxed ? 1.0 : progress))
                                    .stroke(
                                        Color.cryptoGreen, // Matches the 'Back' button blue
                                        style: StrokeStyle(lineWidth: 8, lineCap: .round)
                                    )
                                    .rotationEffect(Angle(degrees: -90))
                                    .frame(width: 60, height: 60)
                                    .animation(.easeInOut(duration: 0.8), value: progress)
                                
                                // Center Icon/Text
                                if isAllMaxed {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.cryptoGreen)
                                        .font(.system(size: 20))
                                } else {
                                    Text("\(Int(progress * 100))%")
                                        .font(.system(size: 12, weight: .bold, design: .monospaced))
                                        .foregroundColor(.white)
                                }
                            }
                        }
                    }
                    .padding()
                    .background(Color.cryptoSurface.opacity(0.5))
                    .cornerRadius(15)

                    .walkthroughHighlight(id: "profile_xp", enabled: viewModel.isOnboarding)
                    .padding(.horizontal)
                    .padding(.bottom, 15)
                    .id("xp_section")
                    
                    // Stats Grid
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
                        StatCard(title: "COINS", value: "\(viewModel.playerStats.coins)", icon: "centsign.circle.fill", color: .yellow)
                            .walkthroughHighlight(id: "profile_coins", enabled: viewModel.isOnboarding)
                            .id("coins_section")

                        
                        StatCard(title: "LEVEL", value: "\(viewModel.playerStats.currentLevelIndex + 1)", icon: "checklist", color: .cryptoGreen)
                            .walkthroughHighlight(id: "profile_level", enabled: viewModel.isOnboarding)
                            .id("level_section")

                        
                        StatCard(title: "XP", value: "\(viewModel.playerStats.experience)", icon: "bolt.fill", color: .orange)
                            .walkthroughHighlight(id: "profile_xp_stat", enabled: viewModel.isOnboarding)
                            .id("xp_stat_section")

                        
                        Button(action: { viewModel.isShowingRiddleView = true }) {
                            StatCard(title: "RIDDLES", value: "\(viewModel.playerStats.completedRiddles.count)", icon: "brain.head.profile", color: .cryptoPurple)
                        }
                        .walkthroughHighlight(id: "profile_riddles", enabled: viewModel.isOnboarding)
                        .id("riddles_section")

                    }
                    .padding(.horizontal)
                    
                    
                    // Achievements Placeholder
                    VStack(alignment: .leading, spacing: 15) {
                        Text("BADGES RECOVERED")
                            .font(.system(size: 14, weight: .black, design: .monospaced))
                            .foregroundColor(.cryptoText)
                            .padding(.horizontal)
                            .padding(.top, 15) // Added top padding inside the new container
                        
                        // Static Badge Collection
                        VStack {
                            let columns = [
                                GridItem(.adaptive(minimum: 70, maximum: 70), spacing: 20)
                            ]
                            
                            LazyVGrid(columns: columns, spacing: 20) {
                                if viewModel.playerStats.hasDeveloperBadge {
                                    DeveloperBadgeView()
                                        .scaleEffect(0.35)
                                        .frame(width: 70, height: 70)
                                }
                                
                                if viewModel.playerStats.hasArchitectBadge {
                                    SystemArchitectBadgeView()
                                        .scaleEffect(0.35)
                                        .frame(width: 70, height: 70)
                                }
                                
                                if viewModel.playerStats.hasSentinelBadge {
                                    CyberSentinelBadgeView()
                                        .scaleEffect(0.35)
                                        .frame(width: 70, height: 70)
                                }
                                
                                if viewModel.playerStats.hasSecurityBadge {
                                    SecurityMasterBadgeView()
                                        .scaleEffect(0.35)
                                        .frame(width: 70, height: 70)
                                }
                                
                                if viewModel.playerStats.hasGrandMasterBadge {
                                    GrandMasterBadgeView()
                                        .scaleEffect(0.35)
                                        .frame(width: 70, height: 70)
                                }
                            }
                            .padding(.horizontal)
                            
                            if !viewModel.playerStats.hasDeveloperBadge && 
                               !viewModel.playerStats.hasArchitectBadge &&
                               !viewModel.playerStats.hasSentinelBadge &&
                               !viewModel.playerStats.hasSecurityBadge &&
                               !viewModel.playerStats.hasGrandMasterBadge {
                                Text("Complete riddles to earn badges.")
                                    .font(.system(size: 12, design: .monospaced))
                                    .foregroundColor(.cryptoSubtext)
                                    .italic()
                                    .padding(.top, 5)
                            }
                        }

    
                    }
                    .padding(.vertical)
                    .background(Color.cryptoSurface.opacity(0.3)) // Added background for consistency with other cards
                    .cornerRadius(12)                             // Added corner radius for consistency
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.cryptoSubtext.opacity(0.1), lineWidth: 1) // Added border
                    )
                    .walkthroughHighlight(id: "profile_badges", enabled: viewModel.isOnboarding)
                    .padding(.horizontal)                         // Ensure padding is outside highlight
                    .id("badges_section")
                    

                    
                    Spacer(minLength: 50)
                }
                .onChange(of: viewModel.currentOnboardingStep) { _, newStep in
                    withAnimation {
                        switch newStep {
                        case .profileCoins:
                            proxy.scrollTo("coins_section", anchor: .center)
                        case .profileLevel:
                            proxy.scrollTo("level_section", anchor: .center)
                        case .profileXPStat:
                            proxy.scrollTo("xp_stat_section", anchor: .center)
                        case .profileRiddles:
                            proxy.scrollTo("riddles_section", anchor: .center)
                        case .profileBadges:
                            proxy.scrollTo("badges_section", anchor: .bottom)
                        case .profileSettings:
                            proxy.scrollTo("settings_section", anchor: .top)
                        case .profileXP:
                            proxy.scrollTo("xp_section", anchor: .center)
                        default:
                            break
                        }
                    }
                }
                .onAppear {
                    // Initial scroll if starting deep in the flow
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        withAnimation {
                            switch viewModel.currentOnboardingStep {
                            case .profileCoins:
                                proxy.scrollTo("coins_section", anchor: .center)
                            case .profileLevel:
                                proxy.scrollTo("level_section", anchor: .center)
                            case .profileXPStat:
                                proxy.scrollTo("xp_stat_section", anchor: .center)
                            case .profileRiddles:
                                proxy.scrollTo("riddles_section", anchor: .center)
                            case .profileBadges:
                                proxy.scrollTo("badges_section", anchor: .bottom)
                            case .profileSettings:
                                proxy.scrollTo("settings_section", anchor: .top)
                            case .profileXP:
                                proxy.scrollTo("xp_section", anchor: .center)
                            default:
                                break
                            }
                        }
                    }
                }
                } // End of ScrollViewReader
            } // End of ScrollView
        }
        .background(Color.cryptoDarkBlue)
        .edgesIgnoringSafeArea(.all)
        .sheet(isPresented: $viewModel.isShowingRiddleView) {
            RiddleMenuView(viewModel: viewModel, onDismiss: { viewModel.isShowingRiddleView = false })
        }
    }
    

    
    
    private func saveName() {
        if !editingName.isEmpty {
            viewModel.updateAgentName(editingName)
        }
        isEditingName = false
    }
}

struct StatCard: View {
    @EnvironmentObject var themeManager: ThemeManager // Force redraw on theme change
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(value)
                .font(.system(size: 20, weight: .black, design: .monospaced))
                .foregroundColor(.cryptoText)
            
            Text(title)
                .font(.system(size: 10, weight: .bold, design: .monospaced))
                .foregroundColor(.cryptoSubtext)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 15)
        .background(Color.cryptoLightNavy.opacity(0.9))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

struct BadgeIcon: View {
    @EnvironmentObject var themeManager: ThemeManager // Force redraw on theme change
    let icon: String
    let color: Color
    let label: String
    
    var body: some View {
        VStack(spacing: 5) {
            Circle()
                .fill(color.opacity(0.1))
                .frame(width: 50, height: 50)
                .overlay(
                    Image(systemName: icon)
                        .foregroundColor(color)
                )
            
            Text(label)
                .font(.system(size: 8, weight: .bold, design: .monospaced))
                .foregroundColor(.cryptoSubtext)
        }
    }
}
