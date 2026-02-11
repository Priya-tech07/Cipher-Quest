
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
                        Image(systemName: "arrow.left")
                            .font(.title2)
                            .foregroundColor(.cryptoText)
                            .padding(10)
                            .background(Color.cryptoNavy)
                            .clipShape(Circle())
                    }
                    Spacer()
                    CoinView(amount: viewModel.playerStats.coins)
                }
                .padding(.horizontal)
                .padding(.top, 10)
                
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
                        
                        // Visible Key
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
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.white)
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
                                Text(viewModel.hintState == .reveal || viewModel.hintState == .secondLetter ? "LETTER REVEALED" : "MISSION INTEL")
                                    .font(.system(size: 10, weight: .bold))
                                    .foregroundColor(.cryptoPurple)
                                
                                if viewModel.hintState == .clue || viewModel.hintState == .reveal || viewModel.hintState == .secondLetter {
                                    Text(level.hint)
                                        .font(.system(size: 16, weight: .medium, design: .rounded))
                                        .foregroundColor(.cryptoText)
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal)
                                        .transition(.scale)
                                }
                                
                                if viewModel.hintState == .reveal {
                                    Text("First letter: \(String(level.plaintext.prefix(1)))")
                                        .font(.system(size: 14, weight: .bold, design: .monospaced))
                                        .foregroundColor(.cryptoGreen)
                                        .padding(.top, 5)
                                }
                                
                                if viewModel.hintState == .secondLetter {
                                    Text("First 2 letters: \(String(level.plaintext.prefix(2)))")
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
                    
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
        }

        .sheet(isPresented: Binding(
            get: { viewModel.gameState == .success },
            set: { _ in }
        )) {
            ResultView(viewModel: viewModel, success: true)
        }
    }
}
