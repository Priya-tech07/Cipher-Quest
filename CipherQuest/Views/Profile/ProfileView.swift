
import SwiftUI

struct ProfileView: View {
    @ObservedObject var viewModel: GameViewModel
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
            .background(Color.white.edgesIgnoringSafeArea(.top))
            
            ScrollView {
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
                                    .foregroundColor(Color(white: 0.15))
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
                                    .font(.system(size: 24, weight: .black, design: .monospaced))
                                    .foregroundColor(Color(white: 0.15))
                                    .multilineTextAlignment(.center)
                                
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
                        
                        Text("ACTIVE AGENT")
                            .font(.system(size: 10, weight: .bold, design: .monospaced))
                            .foregroundColor(.cryptoSubtext)
                    }
                    .padding(.top, -10)
                    
                    // Stats Grid
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
                        StatCard(title: "COINS", value: "\(viewModel.playerStats.coins)", icon: "centsign.circle.fill", color: .yellow)
                            .onboardingTarget(.statCoins)
                        
                        StatCard(title: "MISSIONS", value: "\(viewModel.playerStats.levelsCompleted)", icon: "checklist", color: .cryptoGreen)
                            .onboardingTarget(.statMissions)
                        
                        StatCard(title: "XP", value: "\(viewModel.playerStats.experience)", icon: "bolt.fill", color: .orange)
                            .onboardingTarget(.statXP)
                        
                        Button(action: { viewModel.isShowingRiddleView = true }) {
                            StatCard(title: "RIDDLES", value: "\(viewModel.playerStats.completedRiddles.count)", icon: "brain.head.profile", color: .cryptoPurple)
                        }
                        .onboardingTarget(.profileRiddles) // Track Riddles Button
                    }
                    .padding(.horizontal)
                    
                    // Progress Section
                    VStack(alignment: .leading, spacing: 10) {
                        let currentXP = viewModel.playerStats.experience
                        let riddleMilestones = [500, 1000, 2000, 3000]
                        let nextMilestone = riddleMilestones.first(where: { $0 > currentXP }) ?? 3000
                        let prevMilestone = riddleMilestones.last(where: { $0 <= currentXP }) ?? 0
                        
                        let progress = nextMilestone > prevMilestone ? Double(currentXP - prevMilestone) / Double(nextMilestone - prevMilestone) : 1.0
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

                        HStack {
                            Text(isAllMaxed ? "FULL SYSTEM CLEARANCE" : "NEXT RIDDLE TO UNLOCK: \(nextUnlockName)")
                                .font(.system(size: 11, weight: .bold, design: .monospaced))
                                .foregroundColor(.cryptoSubtext)
                            Spacer()
                            Text(isAllMaxed ? "MAXED" : "\(currentXP)/\(nextMilestone) XP")
                                .font(.system(size: 11, design: .monospaced))
                                .foregroundColor(.cryptoPurple)
                        }
                        
                        ProgressView(value: isAllMaxed ? 1.0 : progress, total: 1.0)
                            .accentColor(.cryptoPurple)
                            .scaleEffect(x: 1, y: 1.5, anchor: .center)
                    }
                    .padding()
                    .background(Color.white.opacity(0.5))
                    .cornerRadius(15)
                    .padding(.horizontal)
                    
                    // Achievements Placeholder
                    VStack(alignment: .leading, spacing: 15) {
                        Text("BADGES RECOVERED")
                            .font(.system(size: 14, weight: .black, design: .monospaced))
                            .foregroundColor(.cryptoText)
                            .padding(.horizontal)
                        
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
                    
                    Spacer(minLength: 50)
                }
            }
        }
        .background(Color.white)
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
        .background(Color.white.opacity(0.9))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

struct BadgeIcon: View {
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
