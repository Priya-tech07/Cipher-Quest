
import SwiftUI

@main
struct CipherQuestApp: App {
    @State private var showLaunchScreen = true
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                ContentView()
                
                if showLaunchScreen {
                    LaunchScreenView(showLaunchScreen: $showLaunchScreen)
                        .transition(.opacity)
                        .zIndex(1)
                }
            }
        }
    }
}
