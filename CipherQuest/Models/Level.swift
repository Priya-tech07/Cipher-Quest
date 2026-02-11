
import Foundation

enum GameMode: String, CaseIterable, Codable {
    case story = "Story Mode"
    case timeTrial = "Time Trial"
    case challenge = "Challenge"
    case daily = "Daily Challenge"
    case practice = "Practice"
}

struct Level: Identifiable, Codable {
    var id: Int
    var title: String
    var storyContext: String
    var difficulty: Int
    var cipherType: CipherType
    var plaintext: String
    var key: String
    var hint: String
    var timeLimit: TimeInterval?
    var rewardCoins: Int
    
    var isUnlocked: Bool = false
    var uniqueID: String { "\(id)-\(cipherType.rawValue)" }
}

struct ChallengeCode: Identifiable, Codable {
    var id = UUID()
    var code: String
    var createdBy: String
    var difficulty: Int
    var cipherType: CipherType
    var encryptedMessage: String
}
