
import SwiftUI

struct ThemePalette {
    // Backgrounds
    let cryptoDarkBlue: String
    let cryptoNavy: String
    let cryptoLightNavy: String
    
    // Accents
    let cryptoGreen: String // Primary Action
    let cryptoPurple: String // Secondary Action
    let cryptoPink: String // Tertiary
    let cryptoYellow: String // Gold
    let cryptoBlue: String // Light Blue
    
    // Text
    let cryptoText: String
    let cryptoSubtext: String
    
    // UI Elements
    let cryptoSurface: String
    let cryptoError: String
}

struct Theme {
    static let light = ThemePalette(
        cryptoDarkBlue: "FFFFFF",  // White background
        cryptoNavy: "F0F4F8",      // Light Blue-Grey
        cryptoLightNavy: "D9E2EC", // Slightly darker for cards
        cryptoGreen: "007AFF",     // Bright Blue (Primary)
        cryptoPurple: "5856D6",    // Indigo
        cryptoPink: "82AAFF",      // Light Blue
        cryptoYellow: "FFD700",    // Gold
        cryptoBlue: "5AC8FA",      // Light Blue
        cryptoText: "102A43",      // Dark Blue/Black
        cryptoSubtext: "486581",   // Muted Blue
        cryptoSurface: "BCCCDC",   // Surface elements
        cryptoError: "D0021B"      // Red
    )
    
    static let dark = ThemePalette(
        cryptoDarkBlue: "102A43",  // Deep Navy Background
        cryptoNavy: "243B53",      // Darker Navy
        cryptoLightNavy: "334E68", // Card Background
        cryptoGreen: "4098D7",     // Lighter Blue for contrast
        cryptoPurple: "7F9CF5",    // Light Indigo
        cryptoPink: "627D98",      // Muted Blue
        cryptoYellow: "F0B429",    // Gold
        cryptoBlue: "63B3ED",      // Light Blue
        cryptoText: "F0F4F8",      // Light Text
        cryptoSubtext: "9FB3C8",   // Muted Light Text
        cryptoSurface: "486581",   // Surface
        cryptoError: "E12D39"      // Red
    )
}
