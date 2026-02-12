
import SwiftUI

struct ResultView: View {
    @ObservedObject var viewModel: GameViewModel
    var success: Bool
    
    var body: some View {
        ZStack {
            // Background
            Color.white.edgesIgnoringSafeArea(.all)
            
            // Dynamic Background (Subtle glow/shapes)
            Circle()
                .fill(success ? Color.cryptoGreen.opacity(0.1) : Color.cryptoError.opacity(0.1))
                .frame(width: 400, height: 400)
                .offset(y: -150)
            
            VStack(spacing: 30) {
                // Icon
                ZStack {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 150, height: 150)
                        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                    
                    Image(systemName: success ? "lock.open.fill" : "lock.fill")
                        .font(.system(size: 60))
                        .foregroundColor(success ? .cryptoGreen : .cryptoError)
                }
                
                // Text
                VStack(spacing: 10) {
                    Text(success ? "ACCESS GRANTED" : "ACCESS DENIED")
                        .font(.system(size: 28, weight: .black, design: .monospaced))
                        .foregroundColor(success ? .cryptoGreen : .cryptoError)
                    
                    Text(success ? "System Integration Complete" : "Authentication Failed")
                        .font(.caption)
                        .foregroundColor(.cryptoSubtext)
                    
                    if success, let level = viewModel.currentLevel {
                        VStack(spacing: 5) {
                            Text("DECRYPTED MESSAGE")
                                .font(.system(size: 10, weight: .bold, design: .monospaced))
                                .foregroundColor(.cryptoSubtext.opacity(0.7))
                                .padding(.top, 10)
                            
                            Text(!viewModel.userInput.isEmpty ? level.plaintext : "")
                                .font(.system(size: 24, weight: .bold, design: .monospaced))
                                .foregroundColor(.cryptoText)
                                .padding()
                                .background(Color.cryptoNavy)
                                .cornerRadius(12)
                        }
                    }
                }
                
                // Reward
                if success, let _ = viewModel.currentLevel {
                    VStack {
                        Text("REWARD")
                            .font(.system(size: 10, weight: .bold))
                            .tracking(2)
                            .foregroundColor(.cryptoSubtext)
                        
                            HStack(spacing: 30) {
                                VStack(spacing: 4) {
                                    Image(systemName: "centsign.circle.fill")
                                        .font(.system(size: 24))
                                        .foregroundColor(.cryptoYellow)
                                    Text("+\(viewModel.lastEarnedCoins)")
                                        .font(.system(size: 16, weight: .bold, design: .monospaced))
                                        .foregroundColor(.cryptoText)
                                }
                                
                                Divider()
                                    .frame(height: 40)
                                    .background(Color.cryptoSubtext.opacity(0.3))
                                
                                VStack(spacing: 4) {
                                    Image(systemName: "bolt.fill")
                                        .font(.system(size: 24))
                                        .foregroundColor(.orange)
                                    Text("+\(viewModel.lastEarnedXP)")
                                        .font(.system(size: 16, weight: .bold, design: .monospaced))
                                        .foregroundColor(.cryptoText)
                                }
                            }
                    }
                    .padding()
                    .frame(width: 200)
                    .background(Color.cryptoNavy)
                    .cornerRadius(15)
                }
                
                Spacer().frame(height: 20)
                
                // Buttons
                Button(action: {
                    if success {
                        if viewModel.currentLevel?.title == "Daily Challenge" {
                            viewModel.showCalendar()
                        } else {
                            viewModel.nextLevel()
                        }
                    } else {
                        // Retry logic - if daily, maybe just restart level?
                        // Assuming startGame handling checks mode.
                        if viewModel.currentLevel?.title == "Daily Challenge" {
                            // Retry daily challenge logic (pass the date if needed, or just standard start)
                            // But usually retry is just resetting the current level state.
                            // GameViewModel.startGame handles init.
                            // For simplicity, let's just re-trigger the daily challenge start if we have the date.
                            // Or just use the existing logic which seems to restart passing mode .story??
                            // Wait, existing retry was `viewModel.startGame(mode: .story)`.
                            // That looks like a bug for Daily Challenge retry!
                            // Let's fix that too.
                            
                            // Checking if we can just reset.
                            // For now, let's stick to the requested redirect change for success.
                            // And try to fix retry if possible.
                            if let date = viewModel.playingDate {
                                viewModel.startDailyChallenge(date: date)
                            } else {
                                viewModel.startGame(mode: .story) // Fallback
                            }
                        } else {
                            viewModel.startGame(mode: .story)
                        }
                    }
                }) {
                    Text(success ? (viewModel.currentLevel?.title == "Daily Challenge" ? "BACK TO CALENDAR" : "NEXT LEVEL") : "RETRY CONNECTION")
                        .font(.headline)
                        .bold()
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(success ? Color.cryptoGreen : Color.cryptoText)
                        .cornerRadius(12)
                        .shadow(color: (success ? Color.cryptoGreen : Color.cryptoText).opacity(0.3), radius: 10, x: 0, y: 5)
                }
                .padding(.horizontal, 50)
                
                Button("RETURN TO BASE") {
                    viewModel.gameState = .menu
                }
                .font(.subheadline)
                .foregroundColor(.cryptoSubtext)
                .padding(.top, 10)
            }
            .padding()
        }
    }
}
