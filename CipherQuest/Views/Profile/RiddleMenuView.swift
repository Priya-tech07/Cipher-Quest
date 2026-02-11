
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
        RiddleLevel(id: 2, title: "SYSTEM ARCHITECT", description: "Locked: Requires Level 10 Clearance.", icon: "lock.circle.fill", xpRequired: 500)
    ]
    
    var body: some View {
        // Navigation Logic
        if let level = selectedLevel {
            // Currently only Level 1 points to the existing Grid View
            if level.id == 1 || level.id == 2 {
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
                    HStack {
                        Button(action: onDismiss) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title)
                                .foregroundColor(.white.opacity(0.6))
                        }
                        Spacer()
                        Text("SECURE ARCHIVES")
                            .font(.system(size: 18, weight: .black, design: .monospaced))
                            .foregroundColor(.cryptoGreen)
                        Spacer()
                        CoinView(amount: viewModel.playerStats.coins)
                            .scaleEffect(0.8)
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
                                        Image(systemName: level.icon)
                                            .font(.title2)
                                            .foregroundColor(viewModel.playerStats.experience >= level.xpRequired ? .cryptoGreen : .gray)
                                        
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
