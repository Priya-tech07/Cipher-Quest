
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
    
    // Streak is now calculated dynamically from completed dates history
    // This is robust against missed updates or local state desync
    var currentStreak: Int {
        let history = completedDates
        if history.isEmpty { return 0 }
        
        let calendar = Calendar.current
        let today = Date()
        let todaySeed = self.seed(for: today)
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!
        let yesterdaySeed = self.seed(for: yesterday)
        
        // Determine start point:
        // If today is done, start counting from today backwards.
        // If today is NOT done but yesterday IS, start counting from yesterday backwards.
        // If neither is done, streak is broken -> 0.
        
        var checkDate = today
        if !history.contains(todaySeed) {
            if history.contains(yesterdaySeed) {
                checkDate = yesterday
            } else {
                return 0
            }
        }
        
        var streak = 0
        while true {
            let seed = self.seed(for: checkDate)
            if history.contains(seed) {
                streak += 1
                // Move back one day
                checkDate = calendar.date(byAdding: .day, value: -1, to: checkDate)!
            } else {
                break
            }
        }
        
        return streak
    }
    
    func markChallengeCompleted(for date: Date = Date()) {
        let seed = self.seed(for: date)
        if !completedDates.contains(seed) {
            // Update history (source of truth)
            var currentHistory = completedDates
            currentHistory.insert(seed)
            UserDefaults.standard.set(Array(currentHistory), forKey: definitionsKey)
            
            // Legacy Ref: We can still update displayed streak for performance if needed,
            // but the computed property above is now the authority.
            // Force a UI update notification if using ObservableObject (not applicable here as singleton)
        }
    }
}
