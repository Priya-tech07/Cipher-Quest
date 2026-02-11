
import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = GameViewModel()
    
    var body: some View {
        ZStack {
            if viewModel.gameState == .menu {
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
                        cipherType: viewModel.currentLevel?.cipherType,
                        onDismiss: {
                            withAnimation { viewModel.isShowingHowToSolve = false }
                        }
                    )
                    .transition(.move(edge: .bottom))
                    .zIndex(1)
                } else if viewModel.isShowingReference {
                    AlphabetReferenceView(
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
            .edgesIgnoringSafeArea(.bottom)
        )
        .overlay(
            Group {
                if viewModel.isShowingOnboarding {
                    OnboardingOverlay(viewModel: viewModel)
                        .transition(.opacity)
                        .zIndex(100)
                }
            }
        )
    }
}
