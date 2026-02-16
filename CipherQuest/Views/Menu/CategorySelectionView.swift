import SwiftUI

struct CategorySelectionView: View {
    @ObservedObject var viewModel: GameViewModel
    
    let categories: [GameCategory] = GameCategory.allCases
    
    var body: some View {
        ZStack {
            Color.cryptoDarkBlue.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                // Header
                VStack(spacing: 10) {
                    ZStack {
                        // Back Button (Aligned to Leading)
                        HStack {
                            Button(action: {
                                withAnimation {
                                    viewModel.gameState = .menu
                                }
                            }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 24, weight: .bold)) // Adjusted size for icon-only
                                .foregroundColor(Color(hex: "007AFF")) // System Blue
                                .padding(10) // Ensure touch target
                                .background(Color.black.opacity(0.001))
                            }
                            Spacer()
                        }
                        .padding(.leading, 10)
                        
                        // Centered Title
                        Text("SELECT CATEGORY")
                            .font(.system(size: 24, weight: .black, design: .monospaced))
                            .foregroundColor(.cryptoText)
                    }
                    
                    Text("Choose your mission field")
                        .font(.system(size: 14, design: .monospaced))
                        .foregroundColor(.cryptoSubtext)
                }
                .padding(.top, 50)
                
                // Categories
                ScrollView {
                    VStack(spacing: 20) {
                        ForEach(categories, id: \.self) { category in
                            Button(action: {
                                viewModel.startGame(mode: viewModel.currentGameMode, preferredType: viewModel.pendingPracticeType, category: category)
                            }) {
                                HStack(spacing: 20) {
                                    Image(systemName: category.icon)
                                        .font(.system(size: 40))
                                        .foregroundColor(category.color)
                                        .frame(width: 60)
                                    
                                    VStack(alignment: .leading, spacing: 5) {
                                        Text(category.displayName)
                                            .font(.system(size: 20, weight: .bold, design: .monospaced))
                                            .foregroundColor(.cryptoText)
                                        
                                        Text(category.description)
                                            .font(.system(size: 12, design: .monospaced))
                                            .foregroundColor(.cryptoSubtext)
                                            .multilineTextAlignment(.leading)
                                    }
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.cryptoSubtext)
                                }
                                .padding(20)
                                .background(Color.cryptoSurface.opacity(0.5))
                                .cornerRadius(15)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(category.color.opacity(0.3), lineWidth: 1)
                                )
                            }
                        }
                    }
                    .padding(.horizontal, 30)
                }
                
                Spacer()
            }
        }
    }
}
