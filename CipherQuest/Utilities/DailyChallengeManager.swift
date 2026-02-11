
import Foundation

class DailyChallengeManager {
    static let shared = DailyChallengeManager()
    
    private let definitionsKey = "CompletedDailyChallenges"
    private let lastPlayedKey = "LastPlayedDailyChallengeDate"
    private let dailyStreakKey = "DailyChallengeStreak"
    
    // Returns a set of all completed date seeds
    var completedDates: Set<Int> {
        let array = UserDefaults.standard.array(forKey: definitionsKey) as? [Int] ?? []
        return Set(array)
    }
    
    private init() {}
    
    // Returns a unique seed for the day (YYYYMMDD)
    var todaySeed: Int {
        return seed(for: Date())
    }
    
    func seed(for date: Date) -> Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        let dateString = formatter.string(from: date)
        return Int(dateString) ?? 0
    }
    
    // Returns the date string for display (e.g., "Oct 24")
    var todayDateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: Date())
    }
    
    var isChallengeCompletedToday: Bool {
        return completedDates.contains(todaySeed)
    }
    
    // Streak is now stored and only updated when playing 'Today'
    var currentStreak: Int {
        let storedStreak = UserDefaults.standard.integer(forKey: dailyStreakKey)
        let lastPlayedSeed = UserDefaults.standard.integer(forKey: lastPlayedKey)
        
        if lastPlayedSeed == 0 { return 0 }
        
        let calendar = Calendar.current
        let todaySeed = self.todaySeed
        let yesterdaySeed = seed(for: calendar.date(byAdding: .day, value: -1, to: Date())!)
        
        // If the last played day was today or yesterday, the streak is still alive
        if lastPlayedSeed == todaySeed || lastPlayedSeed == yesterdaySeed {
            return storedStreak
        }
        
        // Otherwise, the streak has expired
        return 0
    }
    
    func markChallengeCompleted(for date: Date = Date()) {
        let seed = self.seed(for: date)
        if !completedDates.contains(seed) {
            // Update history (always do this for any date)
            var currentHistory = completedDates
            currentHistory.insert(seed)
            UserDefaults.standard.set(Array(currentHistory), forKey: definitionsKey)
            
            // Streak Logic: ONLY update if the date is Today
            if Calendar.current.isDateInToday(date) {
                let calendar = Calendar.current
                let lastPlayedSeed = UserDefaults.standard.integer(forKey: lastPlayedKey)
                let yesterdaySeed = self.seed(for: calendar.date(byAdding: .day, value: -1, to: Date())!)
                
                var newStreak = 1
                if lastPlayedSeed == yesterdaySeed {
                    // Continued from yesterday
                    newStreak = UserDefaults.standard.integer(forKey: dailyStreakKey) + 1
                }
                
                UserDefaults.standard.set(newStreak, forKey: dailyStreakKey)
                UserDefaults.standard.set(seed, forKey: lastPlayedKey)
            }
        }
    }
}
