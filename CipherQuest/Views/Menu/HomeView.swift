
import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: GameViewModel
    
    var body: some View {
        ZStack {
            // Background
            Color.cryptoDarkBlue.edgesIgnoringSafeArea(.all)
            
            // Decorative Circles
            Circle()
                .fill(Color.cryptoGreen.opacity(0.1))
                .frame(width: 300, height: 300)
                .offset(x: -100, y: -200)
            
            Circle()
                .fill(Color.cryptoBlue.opacity(0.1))
                .frame(width: 200, height: 200)
                .offset(x: 100, y: 300)
            
            // Profile Button in Top Right
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        withAnimation { viewModel.isShowingProfile = true }
                    }) {
                        HStack(spacing: 8) {
                            VStack(alignment: .trailing, spacing: 2) {
                                Text(viewModel.playerStats.agentName)
                                    .font(.system(size: 8, weight: .bold, design: .monospaced))
                                    .foregroundColor(.cryptoSubtext)
                                Text("LVL \(viewModel.playerStats.currentLevelIndex + 1)")
                                    .font(.system(size: 12, weight: .black, design: .monospaced))
                                    .foregroundColor(.cryptoGreen)
                            }
                            
                            Image(systemName: "person.crop.circle.fill")
                                .font(.system(size: 32))
                                .foregroundColor(.cryptoGreen)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color.cryptoSurface.opacity(0.8))
                        .cornerRadius(20)
                        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                    }
                    .walkthroughHighlight(id: "profile_button", enabled: viewModel.isOnboarding)

                    .padding(.top, 10)
                    .padding(.trailing, 20)
                }
                Spacer()
            }
            
            VStack(spacing: 20) {
                Spacer()
                
                // Title Section
                VStack(spacing: 15) {
                    Image(systemName: "lock.square.stack.fill")
                        .font(.system(size: 70))
                        .foregroundColor(.cryptoGreen)
                        .shadow(color: .cryptoGreen.opacity(0.4), radius: 10, x: 0, y: 5)
                    
                    Text("CIPHER\nQUEST")
                        .font(.system(size: 56, weight: .black, design: .monospaced))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.cryptoText)
                    
                    Text("CRACK THE CODE")
                        .font(.custom("Menlo", size: 14))
                        .tracking(8)
                        .foregroundColor(.cryptoSubtext)
                }
                
                Spacer()
                
                // Menu Buttons
                VStack(spacing: 20) {
                    // Difficulty Selection
                    MenuButton(title: "EASY MISSION", icon: "arrow.right.circle.fill", color: .cryptoBlue, textColor: .white) {
                         withAnimation { viewModel.showCategorySelection(mode: .story) }
                    }

                    
                    MenuButton(title: "HARD MISSION", icon: "shield.righthalf.filled", color: .cryptoGreen, textColor: .white) {
                         withAnimation { viewModel.showCategorySelection(mode: .practice, preferredType: .caesar) }
                    }

                    
                    MenuButton(title: "DIFFICULT MISSION", icon: "exclamationmark.triangle.fill", color: Color(hex: "2B4E72"), textColor: .white) { // Changed to Navy Blue
                         withAnimation { viewModel.showCategorySelection(mode: .practice, preferredType: .vigenere) }
                    }

                }
                .walkthroughHighlight(id: "difficulty_section", enabled: viewModel.isOnboarding)
                .padding(.horizontal, 40)
                
                Spacer()
                
                // Daily Challenge Calendar
                Button(action: {
                    viewModel.showCalendar()
                }) {
                    VStack(alignment: .leading, spacing: 5) {
                        HStack {
                            Image(systemName: "calendar")
                                .foregroundColor(.white)
                            Text("DAILY CHALLENGE")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            Spacer()
                            if DailyChallengeManager.shared.isChallengeCompletedToday {
                                Image(systemName: "checkmark.seal.fill")
                                .foregroundColor(.yellow)
                            } else {
                                Image(systemName: "lock.open.fill")
                                .foregroundColor(.white.opacity(0.8))
                            }
                        }
                        
                        Text(DailyChallengeManager.shared.todayDateString)
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                        
                        Text(DailyChallengeManager.shared.isChallengeCompletedToday ? "Mission Completed" : "Solve today's puzzle for +50 XP")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                    }
                    .padding()
                    .background(
                        LinearGradient(gradient: Gradient(colors: [Color(hex: "007AFF"), Color(hex: "102A43")]), startPoint: .leading, endPoint: .trailing)
                    )
                    .cornerRadius(15)
                    .shadow(color: Color.black.opacity(0.3), radius: 8, x: 0, y: 4)
                }
                .walkthroughHighlight(id: "daily_challenge_button", enabled: viewModel.isOnboarding)
                .padding(.horizontal, 40)
                .disabled(false) // DailyChallengeManager.shared.isChallengeCompletedToday
                
                Spacer()
                
                VStack(spacing: 8) {
                    Button(action: {
                        withAnimation { viewModel.isShowingHowToSolve = true }
                    }) {
                        HStack {
                            Image(systemName: "questionmark.circle.fill")
                            Text("HOW TO SOLVE")
                        }
                        .font(.system(size: 12, weight: .bold, design: .monospaced))
                        .foregroundColor(.cryptoPurple)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                        .background(Color.cryptoPurple.opacity(0.1))
                        .cornerRadius(20)
                    }
                    .walkthroughHighlight(id: "how_to_solve_button", enabled: viewModel.isOnboarding)

                    
                    Text("SECURE CONNECTION ESTABLISHED")
                        .font(.system(size: 10, design: .monospaced))
                        .foregroundColor(.cryptoSubtext.opacity(0.5))
                    
                    Text("V 1.0.0")
                        .font(.caption2)
                        .foregroundColor(.gray)
                }
                .padding(.bottom, 60)
            }
            
            // Overlays
            // Handled in ContentView now

            
            if viewModel.isShowingHowToSolve {
                HowToSolveView(cipherType: nil, onDismiss: {
                    withAnimation { viewModel.isShowingHowToSolve = false }
                })
                    .transition(.move(edge: .bottom))
                    .zIndex(4)
            }
            

        }
    }
}

struct MenuButton: View {
    var title: String
    var icon: String
    var color: Color
    var textColor: Color
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.title3)
                Text(title)
                    .font(.system(size: 18, weight: .bold, design: .monospaced))
            }
            .foregroundColor(textColor)
            .padding()
            .frame(maxWidth: .infinity)
            .background(color)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.cryptoSubtext.opacity(0.1), lineWidth: 1)
            )
        }
    }
}
