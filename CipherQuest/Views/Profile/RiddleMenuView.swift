
import SwiftUI

struct RiddleLevel: Identifiable {
    let id: Int
    let title: String
    let description: String
    let icon: String
    let xpRequired: Int
}

struct RiddleMenuView: View {
    @ObservedObject var viewModel: GameViewModel
    var onDismiss: () -> Void
    
    @State private var selectedLevel: RiddleLevel?
    
    // Levels Data
    let levels = [
        RiddleLevel(id: 1, title: "MASTER DEVELOPER", description: "Recover the 4 fragments to prove your coding mastery.", icon: "hammer.circle.fill", xpRequired: 0),
        RiddleLevel(id: 2, title: "SYSTEM ARCHITECT", description: "Locked: Requires Level 10 Clearance.", icon: "building.columns.circle.fill", xpRequired: 500),
        RiddleLevel(id: 3, title: "CYBER SENTINEL", description: "Locked: Requires Level 20 Clearance.", icon: "star.circle.fill", xpRequired: 1000),
        RiddleLevel(id: 4, title: "SECURITY MASTER", description: "Locked: Requires Level 40 Clearance.", icon: "checkmark.shield.fill", xpRequired: 2000),
        RiddleLevel(id: 5, title: "GRAND MASTER", description: "Locked: Requires Level 60 Clearance.", icon: "crown.fill", xpRequired: 3000),
        RiddleLevel(id: 6, title: "CRICKET CHAMPION", description: "Prove your knowledge of the pitch and the boundary.", icon: "sportscourt.fill", xpRequired: 4000),
        RiddleLevel(id: 7, title: "CINEMA BUFF", description: "Test your expertise in the world of film and story.", icon: "film.fill", xpRequired: 5000),
        RiddleLevel(id: 8, title: "HISTORY SCHOLAR", description: "Uncover the secrets of the past and civilizations.", icon: "scroll.fill", xpRequired: 6000),
        RiddleLevel(id: 9, title: "GEOGRAPHY EXPLORER", description: "Chart the maps and landscapes of the globe.", icon: "globe.americas.fill", xpRequired: 7000)
    ]
    
    // Check if badge for a level has been earned
    func hasBadge(for levelId: Int) -> Bool {
        switch levelId {
        case 1: return viewModel.playerStats.hasDeveloperBadge
        case 2: return viewModel.playerStats.hasArchitectBadge
        case 3: return viewModel.playerStats.hasSentinelBadge
        case 4: return viewModel.playerStats.hasSecurityBadge
        case 5: return viewModel.playerStats.hasGrandMasterBadge
        case 6: return viewModel.playerStats.hasCricketBadge
        case 7: return viewModel.playerStats.hasCinemaBadge
        case 8: return viewModel.playerStats.hasHistoryBadge
        case 9: return viewModel.playerStats.hasGeographyBadge
        default: return false
        }
    }
    
    var body: some View {
        // Navigation Logic
        if let level = selectedLevel {
            // Currently only Level 1 points to the existing Grid View
            if level.id >= 1 && level.id <= 9 {
                RiddleGridView(viewModel: viewModel, level: level.id, onDismiss: { 
                    withAnimation { selectedLevel = nil }
                })
            }
        } else {
            // Menu View
            ZStack {
                Color.cryptoDarkBlue.edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 20) {
                    // Header

                    ZStack {
                        // Centered Title
                        Text("SECURE ARCHIVES")
                            .font(.system(size: 18, weight: .black, design: .monospaced))
                            .foregroundColor(.cryptoGreen)
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                        // Left & Right Items
                        HStack {
                            BackButton(action: onDismiss)
                            
                            Spacer()
                            
                            CoinView(amount: viewModel.playerStats.coins)
                                .scaleEffect(0.8)
                        }
                    }
                    .padding()
                    
                    Text("Select a classified file to begin decryption.")
                        .font(.caption)
                        .foregroundColor(.cryptoSubtext)
                        
                    ScrollView {
                        VStack(spacing: 15) {
                            ForEach(levels) { level in
                                Button(action: {
                                    if viewModel.playerStats.experience >= level.xpRequired {
                                        withAnimation { selectedLevel = level }
                                    }
                                }) {
                                    HStack(spacing: 15) {
                                        Image(systemName: hasBadge(for: level.id) ? level.icon : (viewModel.playerStats.experience >= level.xpRequired ? "circle.dashed" : "lock.fill"))
                                            .font(.title2)
                                            .foregroundColor(hasBadge(for: level.id) ? .cryptoGreen : .gray)
                                        
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(level.title)
                                                .font(.system(size: 14, weight: .black, design: .monospaced))
                                                .foregroundColor(viewModel.playerStats.experience >= level.xpRequired ? .cryptoText : .gray)
                                            
                                            Text(level.description)
                                                .font(.caption2)
                                                .foregroundColor(.gray)
                                                .multilineTextAlignment(.leading)
                                        }
                                        
                                        Spacer()
                                        
                                        if viewModel.playerStats.experience < level.xpRequired {
                                            Text("\(level.xpRequired) XP")
                                                .font(.system(size: 10, weight: .bold))
                                                .foregroundColor(.cryptoError)
                                        } else {
                                            Image(systemName: "chevron.right")
                                                .font(.caption)
                                                .foregroundColor(.cryptoSubtext)
                                        }
                                    }
                                    .padding()
                                    .background(Color.cryptoNavy.opacity(0.6))
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(viewModel.playerStats.experience >= level.xpRequired ? Color.cryptoGreen.opacity(0.3) : Color.white.opacity(0.05), lineWidth: 1)
                                    )
                                }
                                .disabled(viewModel.playerStats.experience < level.xpRequired)
                            }
                        }
                        .padding()
                    }
                    
                    Spacer()
                }
            }
        }
    }
}
