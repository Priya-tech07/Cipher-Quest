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
                            BackButton(action: {
                                withAnimation {
                                    viewModel.gameState = .menu
                                }
                            })
                            Spacer()
                        }
                        
                        // Centered Title
                        Text("SELECT CATEGORY")
                            .font(.system(size: 24, weight: .black, design: .monospaced))
                            .foregroundColor(.cryptoText)
                    }
                    
                    Text("Choose your mission field")
                        .font(.system(size: 14, design: .monospaced))
                        .foregroundColor(.cryptoSubtext)
                }
                .padding(.top, 10)
                
                // Categories
                ScrollView {
                    VStack(spacing: 20) {
                        ForEach(categories, id: \.self) { category in
                            Button(action: {
                                viewModel.startGame(mode: viewModel.currentGameMode, preferredType: viewModel.pendingPracticeType, category: category)
                            }) {
                                HStack(spacing: 15) {
                                    ZStack {
                                        Circle()
                                            .fill(category.color.opacity(0.2))
                                            .frame(width: 50, height: 50)
                                        Image(systemName: category.icon)
                                            .font(.title2)
                                            .foregroundColor(category.color)
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(category.displayName)
                                            .font(.system(size: 16, weight: .bold, design: .monospaced))
                                            .foregroundColor(.cryptoText)
                                        
                                        Text(category.description)
                                            .font(.system(size: 10, design: .monospaced))
                                            .foregroundColor(.cryptoSubtext)
                                            .multilineTextAlignment(.leading)
                                    }
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.gray)
                                }
                                .padding()
                                .background(Color.cryptoLightNavy)
                                .cornerRadius(15)
                                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
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
