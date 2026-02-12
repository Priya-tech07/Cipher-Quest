
import SwiftUI

struct AlphabetReferenceView: View {
    let cipherType: CipherType?
    let onDismiss: () -> Void
    
    let alphabet = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ")
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            // Drag Handle
            Capsule()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 40, height: 6)
                .padding(.top, 12)
            
            // Header
            HStack {
                Text(cipherType == .atbash ? "ATBASH INDEX" : "ALPHABET INDEX")
                    .font(.system(size: 18, weight: .black, design: .monospaced))
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
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(0..<alphabet.count, id: \.self) { index in
                        VStack(spacing: 4) {
                            Text(String(alphabet[index]))
                                .font(.system(size: 22, weight: .bold, design: .monospaced))
                                .foregroundColor(.cryptoGreen)
                            
                            if cipherType == .atbash {
                                // Atbash: Show Reverse Mapping (A -> Z)
                                VStack(spacing: 2) {
                                    Text(String(alphabet[25 - index]))
                                        .font(.system(size: 22, weight: .bold, design: .monospaced))
                                        .foregroundColor(.cryptoPurple)
                                }
                                .padding(.horizontal, 6)
                                .padding(.vertical, 4)
                                .background(Color.cryptoPurple.opacity(0.1))
                                .cornerRadius(4)
                            } else {
                                // Standard: Show Indices
                                HStack(spacing: 6) {
                                    Text(String(format: "%02d", index + 1))
                                        .font(.system(size: 13, weight: .bold, design: .monospaced))
                                        .foregroundColor(.cryptoPurple)
                                    
                                    Text(String(format: "%02d", 26 - index))
                                        .font(.system(size: 11, weight: .medium, design: .monospaced))
                                        .foregroundColor(.cryptoSubtext.opacity(0.6))
                                }
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color.cryptoPurple.opacity(0.1))
                                .cornerRadius(4)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color.white.opacity(0.9))
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.03), radius: 3, x: 0, y: 1)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
            
            Text(cipherType == .atbash ? "MISSION INTEL: ATBASH REFLECTION MAP" : "MISSION INTEL: DUAL INDEX (1-26 & 26-1) MAP")
                .font(.system(size: 10, weight: .bold, design: .monospaced))
                .foregroundColor(.cryptoSubtext)
                .padding(.bottom, 30)
        }
        .background(.ultraThinMaterial)
        .background(Color.cryptoNavy.opacity(0.7))
        .cornerRadius(30)
        .shadow(color: Color.black.opacity(0.15), radius: 15, x: 0, y: -5)
        .edgesIgnoringSafeArea(.bottom)
    }
}
