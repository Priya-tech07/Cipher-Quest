
import Foundation

class DailyChallengeManager {
    static let shared = DailyChallengeManager()
    
    private let definitionsKey = "CompletedDailyChallenges"
    private let strictDefinitionsKey = "StrictCompletedDailyChallenges"
    
    // Returns a set of all completed date seeds
    var completedDates: Set<Int> {
        let array = UserDefaults.standard.array(forKey: definitionsKey) as? [Int] ?? []
        return Set(array)
    }
    
    // Returns a set of dates completed ON THE DAY itself (Strict)
    var strictCompletedDates: Set<Int> {
        get {
            if let array = UserDefaults.standard.array(forKey: strictDefinitionsKey) as? [Int] {
                return Set(array)
            } else {
                // Migration: If no strict history exists, assume existing history is valid
                // to prevent resetting active users' streaks.
                let existing = completedDates
                if !existing.isEmpty {
                    UserDefaults.standard.set(Array(existing), forKey: strictDefinitionsKey)
                    return existing
                }
                return []
            }
        }
    }
    
    private init() {}
    
    // Returns a unique seed for the day (YYYYMMDD)
    var todaySeed: Int {
        return seed(for: Date())
    }
    
    func seed(for date: Date) -> Int {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: date)
        let year = components.year ?? 0
        let month = components.month ?? 0
        let day = components.day ?? 0
        return year * 10000 + month * 100 + day
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
    
    // Streak is now calculated dynamically from STRICT completed dates history
    var currentStreak: Int {
        let history = strictCompletedDates
        if history.isEmpty { return 0 }
        
        let calendar = Calendar.current
        
        // Start checking from Today (normalized to start of day)
        var checkDate = calendar.startOfDay(for: Date())
        
        // Check Today
        var seed = self.seed(for: checkDate)
        
        // If today is NOT done, we check Yesterday.
        // If Yesterday is NOT done, streak is broken.
        if !history.contains(seed) {
            // Check Yesterday
            guard let yesterday = calendar.date(byAdding: .day, value: -1, to: checkDate) else { return 0 }
            checkDate = yesterday
            seed = self.seed(for: checkDate)
            
            if !history.contains(seed) {
                return 0
            }
        }
        
        // If we are here, 'checkDate' is the most recent completed day (Today or Yesterday)
        // Now count backwards
        var streak = 0
        while history.contains(seed) {
            streak += 1
            // Move back one day
            guard let prevDate = calendar.date(byAdding: .day, value: -1, to: checkDate) else { break }
            checkDate = prevDate
            seed = self.seed(for: checkDate)
        }
        
        return streak
    }
    
    func markChallengeCompleted(for date: Date = Date()) {
        let seed = self.seed(for: date)
        
        // 1. Mark as visually completed (Blue)
        if !completedDates.contains(seed) {
            var currentHistory = completedDates
            currentHistory.insert(seed)
            UserDefaults.standard.set(Array(currentHistory), forKey: definitionsKey)
        }
        
        // 2. Mark as STRICTLY completed (Green/Streak) ONLY if it's today
        // We use Calendar to check if 'date' is actually Today.
        if Calendar.current.isDateInToday(date) {
             var currentStrictHistory = strictCompletedDates
             if !currentStrictHistory.contains(seed) {
                 currentStrictHistory.insert(seed)
                 UserDefaults.standard.set(Array(currentStrictHistory), forKey: strictDefinitionsKey)
             }
        }
    }
}
