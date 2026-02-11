
import SwiftUI

struct ProfileView: View {
    @ObservedObject var viewModel: GameViewModel
    var onDismiss: () -> Void
    
    @State private var isEditingName = false
    @State private var editingName = ""
    
    var body: some View {
        VStack(spacing: 0) {
            // Top Safe Area Spacer
            Color.clear.frame(height: 44)
            
            // Drag Handle
            Capsule()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 40, height: 6)
                .padding(.top, 8)
            
            // Header
            HStack {
                Text("AGENT PROFILE")
                    .font(.system(size: 20, weight: .black, design: .monospaced))
                    .foregroundColor(.cryptoText)
                
                Spacer()
                
                Button(action: onDismiss) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(.gray.opacity(0.5))
                }
            }
            .padding()
            
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
                        StatCard(title: "MISSIONS", value: "\(viewModel.playerStats.levelsCompleted)", icon: "checklist", color: .cryptoGreen)
                        StatCard(title: "XP", value: "\(viewModel.playerStats.experience)", icon: "bolt.fill", color: .orange)
                        
                        Button(action: { viewModel.isShowingRiddleView = true }) {
                            StatCard(title: "RIDDLES", value: "\(viewModel.playerStats.completedRiddles.count)", icon: "brain.head.profile", color: .cryptoPurple)
                        }
                        .onboardingTarget(.profileRiddles) // Track Riddles Button
                    }
                    .padding(.horizontal)
                    .onboardingTarget(.profileStats) // Track Stats Grid
                    
                    // Progress Section
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("LEVEL PROGRESS")
                                .font(.system(size: 12, weight: .bold, design: .monospaced))
                                .foregroundColor(.cryptoSubtext)
                            Spacer()
                            Text("\(viewModel.playerStats.experience % 50)/50 XP")
                                .font(.system(size: 12, design: .monospaced))
                                .foregroundColor(.cryptoPurple)
                        }
                        
                        ProgressView(value: Double(viewModel.playerStats.experience % 50), total: 50)
                            .accentColor(.cryptoPurple)
                            .scaleEffect(x: 1, y: 2, anchor: .center)
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
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 20) {
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
                                
                                if !viewModel.playerStats.hasDeveloperBadge && !viewModel.playerStats.hasArchitectBadge {
                                    Text("Complete riddles to earn badges.")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                        .italic()
                                        .padding(.vertical, 10)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.vertical)
                    
                    Spacer(minLength: 50)
                }
            }
        }
        .background(.ultraThinMaterial)
        .background(Color.cryptoNavy.opacity(0.8))
        .cornerRadius(30, corners: [.topLeft, .topRight])
        .shadow(color: Color.black.opacity(0.15), radius: 15, x: 0, y: -5)
        .edgesIgnoringSafeArea(.bottom)
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
