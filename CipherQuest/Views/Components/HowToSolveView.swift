
import SwiftUI

struct HowToSolveView: View {
    // If a specific cipher is passed, we might want to open it directly or highlight it.
    // For now, we'll just show the menu for exploration.
    let cipherType: CipherType?
    let onDismiss: () -> Void
    
    @State private var selectedCipher: CipherType? = nil
    
    var body: some View {
        ZStack {
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
                        .padding(10) // Increase hit area
                    }
                    
                    Spacer()
                    
                    Text("CIPHER ACADEMY")
                        .font(.system(size: 18, weight: .black, design: .monospaced))
                        .foregroundColor(.cryptoText)
                        .padding(.top, 10) // Align with button
                    
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
                .padding(.bottom, 15) // Bottom spacing
                .padding(.top, 50) // Push down from status bar
                .background(Color.cryptoNavy)
                
                ScrollView {
                    VStack(spacing: 20) {
                        Text("SELECT A MODULE")
                            .font(.system(size: 14, weight: .bold, design: .monospaced))
                            .foregroundColor(.cryptoSubtext)
                            .padding(.top)
                        
                        // Menu Cards
                        CipherCard(title: "CAESAR CIPHER", icon: "arrow.triangle.2.circlepath", color: .cryptoGreen) {
                            withAnimation { selectedCipher = .caesar }
                        }
                        
                        CipherCard(title: "VIGENÈRE CIPHER", icon: "text.aligncenter", color: .cryptoPurple) {
                            withAnimation { selectedCipher = .vigenere }
                        }
                        
                        CipherCard(title: "PLAYFAIR CIPHER", icon: "grid", color: .cryptoBlue) {
                            withAnimation { selectedCipher = .playfair }
                        }
                        

                    }
                    .padding()
                }
            }
            .background(Color.white)
            .cornerRadius(20, corners: [.topLeft, .topRight])
            .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: -5)
            
            // Tutorial Overlay
            if let cipher = selectedCipher {
                CipherTutorialView(cipherType: cipher, isPresented: Binding(
                    get: { selectedCipher != nil },
                    set: { if !$0 { selectedCipher = nil } }
                ))
                .transition(.move(edge: .trailing))
                .zIndex(1)
            }
        }
        .onAppear {
            if let cipher = cipherType {
                selectedCipher = cipher
            }
        }
    }
}

struct CipherCard: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 15) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.2))
                        .frame(width: 50, height: 50)
                    Image(systemName: icon)
                        .font(.title2)
                        .foregroundColor(color)
                }
                
                Text(title)
                    .font(.system(size: 16, weight: .bold, design: .monospaced))
                    .foregroundColor(.cryptoText)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(15)
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(color.opacity(0.3), lineWidth: 1)
            )
        }
    }
}
