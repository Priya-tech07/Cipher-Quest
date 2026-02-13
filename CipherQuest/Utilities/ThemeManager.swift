
import SwiftUI

class ThemeManager: ObservableObject {
    @AppStorage("isDarkMode") var isDarkMode: Bool = false
    
    static let shared = ThemeManager()
    
    var currentPalette: ThemePalette {
        return isDarkMode ? Theme.dark : Theme.light
    }
}
