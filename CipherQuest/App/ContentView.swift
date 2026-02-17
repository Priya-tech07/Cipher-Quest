
import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = GameViewModel()
    @StateObject private var themeManager = ThemeManager.shared

    
    @State private var walkthroughSteps: [String: CGRect] = [:]
    
    var body: some View {
        ZStack {
            if viewModel.gameState == .menu || viewModel.gameState == .categorySelect {
                HomeView(viewModel: viewModel)
                    .transition(.opacity)
            } else if viewModel.gameState == .calendar {
                CalendarView(viewModel: viewModel)
                    .transition(.opacity)
            } else {
                PuzzleView(viewModel: viewModel)
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.6), value: viewModel.gameState)
        .overlay(
            ZStack(alignment: .bottom) {
                if viewModel.isShowingHowToSolve || viewModel.isShowingReference || viewModel.isShowingProfile {
                    Color.black.opacity(0.4)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            withAnimation { 
                                viewModel.isShowingHowToSolve = false 
                                viewModel.isShowingReference = false
                                viewModel.isShowingProfile = false
                            }
                        }
                        .transition(.opacity)
                }

                if viewModel.isShowingHowToSolve {
                    HowToSolveView(
                        cipherType: viewModel.gameState == .playing ? viewModel.currentLevel?.cipherType : nil,
                        onDismiss: {
                            withAnimation { viewModel.isShowingHowToSolve = false }
                        }
                    )
                    .transition(.move(edge: .bottom))
                    .zIndex(1)
                } else if viewModel.isShowingReference {
                    AlphabetReferenceView(
                        cipherType: viewModel.currentLevel?.cipherType,
                        onDismiss: {
                            withAnimation { viewModel.isShowingReference = false }
                        }
                    )
                    .transition(.move(edge: .bottom))
                    .zIndex(2)
                } else if viewModel.isShowingProfile {
                    ProfileView(
                        viewModel: viewModel,
                        onDismiss: {
                            withAnimation { viewModel.isShowingProfile = false }
                        }
                    )
                    .transition(.move(edge: .bottom))
                    .zIndex(3)
                }
                
                // Onboarding Overlays
                if viewModel.isOnboarding {
                    if viewModel.currentOnboardingStep == .nameInput {
                        NameInputView(viewModel: viewModel)
                            .zIndex(100)
                            .transition(.opacity)
                    } else if viewModel.currentOnboardingStep != .completed {
                        WalkthroughOverlay(viewModel: viewModel, steps: walkthroughSteps)
                            .zIndex(99)
                            .transition(.opacity)
                    }
                }
            }
            .edgesIgnoringSafeArea(.all)
        )
        .onPreferenceChange(WalkthroughHighlightKey.self) { preferences in
            self.walkthroughSteps = preferences
        }
        .environmentObject(themeManager)
        .preferredColorScheme(themeManager.isDarkMode ? .dark : .light)
    }
}

