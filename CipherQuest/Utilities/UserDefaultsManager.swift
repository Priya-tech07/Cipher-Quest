
import Foundation

class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    
    private let defaults = UserDefaults.standard
    
    private let statsKey = "playerStats"
    private let unlockedLevelsKey = "unlockedLevels"
    
    private init() {}
    
    func saveStats(_ stats: PlayerStats) {
        if let encoded = try? JSONEncoder().encode(stats) {
            defaults.set(encoded, forKey: statsKey)
        }
    }
    
    func loadStats() -> PlayerStats {
        if let data = defaults.data(forKey: statsKey),
           let decoded = try? JSONDecoder().decode(PlayerStats.self, from: data) {
            return decoded
        }
        return PlayerStats() // Default clean stats
    }
    
    func resetData() {
        defaults.removeObject(forKey: statsKey)
    }
}
