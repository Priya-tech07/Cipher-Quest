
import SwiftUI

// Shared Highlight Areas
enum HighlightArea: String, CaseIterable {
    case topRight = "topRight" // Profile Button
    case bottom = "bottom" // How to Solves
    case center = "center" // Missions
    case profileStats = "profileStats" // Stats Grid
    case profileRiddles = "profileRiddles" // Riddles Section
}

// Preference Key to aggregate target frames
struct OnboardingPreferenceKey: PreferenceKey {
    typealias Value = [HighlightArea: CGRect]
    
    static var defaultValue: [HighlightArea: CGRect] = [:]
    
    static func reduce(value: inout [HighlightArea: CGRect], nextValue: () -> [HighlightArea: CGRect]) {
        value.merge(nextValue()) { _, new in new }
    }
}

// View Extension to easily tag targets
extension View {
    func onboardingTarget(_ area: HighlightArea) -> some View {
        self.background(
            GeometryReader { geo in
                Color.clear
                    .preference(
                        key: OnboardingPreferenceKey.self,
                        value: [area: geo.frame(in: .global)]
                    )
            }
        )
    }
}
