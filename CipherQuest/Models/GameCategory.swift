import SwiftUI

enum GameCategory: String, CaseIterable, Codable {
    case coding = "Coding"
    case cricket = "Cricket"
    case cinema = "Cinema"
    
    var displayName: String {
        return self.rawValue.uppercased()
    }
    
    var icon: String {
        switch self {
        case .coding: return "laptopcomputer"
        case .cricket: return "figure.cricket"
        case .cinema: return "film.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .coding: return .cryptoBlue
        case .cricket: return .cryptoGreen
        case .cinema: return .cryptoPurple
        }
    }
    
    var description: String {
        switch self {
        case .coding: return "Hack the mainframe with tech terms."
        case .cricket: return "Hit a six with cricket trivia."
        case .cinema: return "Guess the blockbuster movie terms."
        }
    }
}
