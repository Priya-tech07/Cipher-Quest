
import SwiftUI

extension Color {
    // Backgrounds
    static var cryptoDarkBlue: Color { Color(hex: ThemeManager.shared.currentPalette.cryptoDarkBlue) }
    static var cryptoNavy: Color { Color(hex: ThemeManager.shared.currentPalette.cryptoNavy) }
    static var cryptoLightNavy: Color { Color(hex: ThemeManager.shared.currentPalette.cryptoLightNavy) }
    
    // Accents
    static var cryptoGreen: Color { Color(hex: ThemeManager.shared.currentPalette.cryptoGreen) }
    static var cryptoPurple: Color { Color(hex: ThemeManager.shared.currentPalette.cryptoPurple) }
    static var cryptoPink: Color { Color(hex: ThemeManager.shared.currentPalette.cryptoPink) }
    static var cryptoYellow: Color { Color(hex: ThemeManager.shared.currentPalette.cryptoYellow) }
    static var cryptoBlue: Color { Color(hex: ThemeManager.shared.currentPalette.cryptoBlue) }
    
    // Text
    static var cryptoText: Color { Color(hex: ThemeManager.shared.currentPalette.cryptoText) }
    static var cryptoSubtext: Color { Color(hex: ThemeManager.shared.currentPalette.cryptoSubtext) }
    
    // UI Elements
    static var cryptoSurface: Color { Color(hex: ThemeManager.shared.currentPalette.cryptoSurface) }
    static var cryptoError: Color { Color(hex: ThemeManager.shared.currentPalette.cryptoError) }
    
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
    
    func glow(color: Color = .cryptoGreen, radius: CGFloat = 8) -> some View {
        self
            .shadow(color: color.opacity(0.4), radius: radius / 2, x: 0, y: 2) // Softer shadow for light mode
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
