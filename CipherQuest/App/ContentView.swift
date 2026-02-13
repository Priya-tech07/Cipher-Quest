
import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = GameViewModel()
    @StateObject private var themeManager = ThemeManager.shared
    @State private var onboardingTargets: [HighlightArea: CGRect] = [:]
    
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
        .animation(.easeInOut, value: viewModel.gameState)
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
            }
            .edgesIgnoringSafeArea(.all)
        )
        .onPreferenceChange(OnboardingPreferenceKey.self) { preferences in
            self.onboardingTargets = preferences
        }
        .overlay(
            Group {
                if viewModel.isShowingOnboarding {
                    OnboardingOverlay(viewModel: viewModel, targetFrames: onboardingTargets)
                        .transition(.opacity)
                        .zIndex(100)
                }
            }
        )
        .environmentObject(themeManager)
        .preferredColorScheme(themeManager.isDarkMode ? .dark : .light)
    }
}

