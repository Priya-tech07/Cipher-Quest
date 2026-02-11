
import SwiftUI

extension Color {
    // Backgrounds
    static let cryptoDarkBlue = Color(hex: "FFFFFF") // White background
    static let cryptoNavy = Color(hex: "F0F4F8") // Light Blue-Grey for gradients
    static let cryptoLightNavy = Color(hex: "D9E2EC") // Slightly darker for cards
    
    // Accents (Remapped to Blue/White Scheme)
    static let cryptoGreen = Color(hex: "007AFF") // Bright Blue (Primary Action)
    static let cryptoPurple = Color(hex: "5856D6") // Indigo (Secondary Action) - Kept as is, it's bluish
    static let cryptoPink = Color(hex: "82AAFF") // Light Blue (Tertiary)
    static let cryptoYellow = Color(hex: "FFD700") // Gold (Coins/Hints)
    static let cryptoBlue = Color(hex: "5AC8FA") // Light Blue
    
    // Text
    static let cryptoText = Color(hex: "102A43") // Dark Blue/Black for text
    static let cryptoSubtext = Color(hex: "486581") // Muted Blue for subtext
    
    // UI Elements
    static let cryptoSurface = Color(hex: "BCCCDC") // Surface elements
    static let cryptoError = Color(hex: "D0021B") // Red
    
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
