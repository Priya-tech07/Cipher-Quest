
import SwiftUI

struct WalkthroughHighlightKey: PreferenceKey {
    static var defaultValue: [String: CGRect] = [:]
    
    static func reduce(value: inout [String: CGRect], nextValue: () -> [String: CGRect]) {
        value.merge(nextValue(), uniquingKeysWith: { $1 })
    }
}

struct WalkthroughHighlightModifier: ViewModifier {
    let id: String
    var enabled: Bool = true
    
    func body(content: Content) -> some View {
        content
            .background(
                Group {
                    if enabled {
                        GeometryReader { geometry in
                            Color.clear.preference(
                                key: WalkthroughHighlightKey.self,
                                value: [id: geometry.frame(in: .global)]
                            )
                        }
                    }
                }
            )
    }
}

extension View {
    func walkthroughHighlight(id: String, enabled: Bool = true) -> some View {
        self.modifier(WalkthroughHighlightModifier(id: id, enabled: enabled))
    }
}
