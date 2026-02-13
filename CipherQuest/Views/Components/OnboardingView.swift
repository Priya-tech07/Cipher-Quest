import SwiftUI

struct OnboardingView: View {
    @ObservedObject var viewModel: GameViewModel
    @State private var currentPage = 0
    
    var body: some View {
        ZStack {
            Color.cryptoDarkBlue.edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                
                TabView(selection: $currentPage) {
                    OnboardingPage(image: "lock.shield", title: "WELCOME AGENT", description: "Your mission is to crack codes and solve riddles to secure the network.")
                        .tag(0)
                    
                    OnboardingPage(image: "text.magnifyingglass", title: "DECIPHER", description: "Use different cipher techniques like Caesar and Vigenère to decode secret messages.")
                        .tag(1)
                    
                    OnboardingPage(image: "brain.head.profile", title: "SOLVE RIDDLES", description: "Complete riddles to earn XP and unlock new security badges.")
                        .tag(2)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                .frame(height: 400)
                
                Spacer()
                
                Button(action: {
                    if currentPage < 2 {
                        withAnimation {
                            currentPage += 1
                        }
                    } else {
                        withAnimation {
                            viewModel.completeOnboarding()
                        }
                    }
                }) {
                    Text(currentPage < 2 ? "NEXT" : "START MISSION")
                        .font(.system(size: 18, weight: .bold, design: .monospaced))
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.cryptoGreen)
                        .cornerRadius(12)
                        .shadow(radius: 5)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 50)
            }
        }
    }
}

struct OnboardingPage: View {
    let image: String
    let title: String
    let description: String
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: image)
                .font(.system(size: 80))
                .foregroundColor(.cryptoGreen)
                .padding()
                .background(Circle().fill(Color.cryptoGreen.opacity(0.1)).frame(width: 150, height: 150))
            
            Text(title)
                .font(.system(size: 24, weight: .black, design: .monospaced))
                .foregroundColor(.cryptoText)
            
            Text(description)
                .font(.system(size: 16, design: .monospaced))
                .foregroundColor(.cryptoSubtext)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
    }
}
