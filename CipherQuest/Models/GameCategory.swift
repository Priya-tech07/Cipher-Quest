import SwiftUI

enum GameCategory: String, CaseIterable, Codable {
    case coding = "Coding"
    case cricket = "Cricket"
    case cinema = "Cinema"
    case geography = "Geography"
    case history = "History"
    
    var displayName: String {
        return self.rawValue.uppercased()
    }
    
    var icon: String {
        switch self {
        case .coding: return "laptopcomputer"
        case .cricket: return "figure.cricket"
        case .cinema: return "film.fill"
        case .geography: return "globe.americas.fill"
        case .history: return "scroll.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .coding: return .cryptoBlue
        case .cricket: return .cryptoGreen
        case .cinema: return .cryptoPurple
        case .geography: return .blue
        case .history: return .orange
        }
    }
    
    var description: String {
        switch self {
        case .coding: return "Hack the mainframe with tech terms."
        case .cricket: return "Hit a six with cricket trivia."
        case .cinema: return "Guess the blockbuster movie terms."
        case .geography: return "Explore the world map."
        case .history: return "Travel back in time."
        }
    }
}
