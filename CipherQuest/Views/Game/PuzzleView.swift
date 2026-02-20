
import SwiftUI

struct PuzzleView: View {
    @ObservedObject var viewModel: GameViewModel
    @State private var showRules: Bool = false
    
    var body: some View {
        ZStack {
            // Background
            Color.cryptoDarkBlue.edgesIgnoringSafeArea(.all) // White
            
            VStack(spacing: 25) {
                // Header
                HStack {
                    Button(action: { viewModel.gameState = .menu }) {
                        HStack(spacing: 5) {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                        .font(.system(size: 16, weight: .bold, design: .monospaced))
                        .foregroundColor(.cryptoGreen)
                        .padding(10)
                    }
                    Spacer()
                    CoinView(amount: viewModel.playerStats.coins)
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
                
                // Timer
                if let level = viewModel.currentLevel, level.timeLimit != nil {
                    TimerView(manager: viewModel.timerManager)
                        .glow(color: .cryptoGreen, radius: 5)
                }
                
                Spacer()
                
                // Puzzle Content
                if let level = viewModel.currentLevel {
                    VStack(spacing: 15) {
                        Text(level.title)
                            .font(.system(size: 20, weight: .bold, design: .monospaced))
                            .foregroundColor(.cryptoGreen)
                            .tracking(2)
                        
                        Text(level.cipherType.rawValue.uppercased())
                            .font(.system(size: 12, weight: .medium, design: .monospaced))
                            .foregroundColor(.cryptoSubtext)
                        

                        
                        Text(level.cipherType.description)
                            .font(.system(size: 12, design: .monospaced))
                            .foregroundColor(.cryptoSubtext.opacity(0.8))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                            .walkthroughHighlight(id: "game_cipher_info", enabled: viewModel.isOnboarding)
                        
                        // Visible Key
                        if level.cipherType != .atbash {
                            HStack {
                                Text(level.cipherType == .caesar ? "SHIFT:" : "KEY:")
                                    .font(.system(size: 14, weight: .bold, design: .monospaced))
                                    .foregroundColor(.cryptoSubtext)
                                
                                Text(level.key)
                                    .font(.system(size: 18, weight: .black, design: .monospaced))
                                    .foregroundColor(.cryptoPurple)
                                    .glow(color: .cryptoPurple, radius: 2)
                            }
                            .padding(.vertical, 5)
                        }
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.cryptoNavy)
                                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.cryptoGreen.opacity(0.2), lineWidth: 1)
                                )
                                .frame(height: 160)
                            
                            if let cipher = viewModel.currentCipher {
                                Text(cipher.encrypt(level.plaintext, key: level.key))
                                    .font(.system(size: 32, weight: .bold, design: .monospaced))
                                    .foregroundColor(.cryptoText)
                                    .padding()
                            }
                        }
                        .padding(.horizontal, 30)
                        
                        if viewModel.hintState != .none {
                            VStack(spacing: 5) {
                                // Dynamic Header
                                let isRevealed: Bool = {
                                    if case .revealed(_) = viewModel.hintState { return true }
                                    return false
                                }()
                                
                                Text(isRevealed ? "LETTER REVEALED" : "MISSION INTEL")
                                    .font(.system(size: 10, weight: .bold))
                                    .foregroundColor(.cryptoPurple)
                                
                                if viewModel.hintState != .none {
                                    Text(level.hint)
                                        .font(.system(size: 16, weight: .medium, design: .rounded))
                                        .foregroundColor(.cryptoText)
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal)
                                        .transition(.scale)
                                }
                                
                                if case .revealed(let count) = viewModel.hintState {
                                    Text("First \(count) letters: \(String(level.plaintext.prefix(count)))")
                                        .font(.system(size: 14, weight: .bold, design: .monospaced))
                                        .foregroundColor(.cryptoGreen)
                                        .padding(.top, 5)
                                }
                            }
                            .padding(.top, 10)
                        }
                    }
                }
                
                Spacer()
                
                // Input Area
                VStack(spacing: 15) {
                    HStack(spacing: 10) {
                        ZStack(alignment: .leading) {
                            if viewModel.userInput.isEmpty {
                                Text("ENTER DECRYPTED TEXT")
                                    .foregroundColor(.cryptoSubtext.opacity(0.5))
                                    .font(.system(size: 14, design: .monospaced))
                                    .padding(.horizontal) // Match TextField padding
                            }
                            TextField("", text: $viewModel.userInput)
                                .font(.system(size: 18, weight: .bold, design: .monospaced))
                                .foregroundColor(.cryptoText)
                                .disableAutocorrection(true)
                                .autocapitalization(.allCharacters)
                                .accentColor(.blue) // Set cursor color to blue
                        }
                        .padding()
                        .background(Color.cryptoNavy)
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.cryptoGreen.opacity(0.5), lineWidth: 1)
                        )
                        
                        Button(action: {
                            withAnimation {
                                viewModel.submitAnswer()
                            }
                        }) {
                            Image(systemName: "arrow.right")
                                .font(.title2)
                                .foregroundColor(.white)
                                .frame(width: 50, height: 50)
                                .background(Color.cryptoGreen)
                                .cornerRadius(12)
                                .shadow(color: .cryptoGreen.opacity(0.3), radius: 5)
                        }
                    }
                    .padding(.horizontal, 30)
                    
                    if let message = viewModel.feedbackMessage {
                        Text(message)
                            .font(.caption)
                            .bold()
                            .foregroundColor(.cryptoError)
                    }
                }
                .padding(.bottom, 20)
                
                HStack(spacing: 12) {
                    HintButton(action: { viewModel.useHint() }, cost: viewModel.hintState.cost)
                        .walkthroughHighlight(id: "game_hint_button", enabled: viewModel.isOnboarding)
                    
                    Button(action: {
                        withAnimation { viewModel.isShowingReference = true }
                    }) {
                        HStack {
                            Image(systemName: "list.number")
                            Text("INDEX")
                        }
                        .font(.system(size: 14, weight: .bold, design: .monospaced))
                        .foregroundColor(.white)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 15)
                        .background(Color.cryptoBlue)
                        .cornerRadius(12)
                        .shadow(color: .cryptoBlue.opacity(0.3), radius: 5)
                    }
                    .walkthroughHighlight(id: "game_index_button", enabled: viewModel.isOnboarding)

                    Button(action: {
                        withAnimation { viewModel.isShowingHowToSolve = true }
                    }) {
                        HStack {
                            Image(systemName: "questionmark.circle")
                            Text("HELP")
                        }
                        .font(.system(size: 14, weight: .bold, design: .monospaced))
                        .foregroundColor(.white)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 15)
                        .background(Color.cryptoPurple)
                        .cornerRadius(12)
                        .shadow(color: .cryptoPurple.opacity(0.3), radius: 5)
                    }
                    .walkthroughHighlight(id: "game_help_button", enabled: viewModel.isOnboarding)
                    
                    Spacer()
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }

        .fullScreenCover(isPresented: Binding(
            get: { viewModel.gameState == .success },
            set: { _ in }
        )) {
            ResultView(viewModel: viewModel, success: true)
        }
    }
}
