
import SwiftUI

class GameViewModel: ObservableObject {
    @Published var currentLevel: Level?
    @Published var playerStats: PlayerStats
    @Published var gameState: GameState = .menu
    @Published var isShowingHowToSolve = false
    @Published var isShowingReference = false
    @Published var isShowingProfile = false
    @Published var isShowingRiddleView = false
    @Published var isShowingOnboarding = false
    @Published var userInput: String = ""
    @Published var feedbackMessage: String?
    @Published var hintState: HintState = .none
    // Track attempts
    var attempts: Int = 0
    @Published var lastEarnedCoins: Int = 0
    @Published var lastEarnedXP: Int = 0
    
    // Track the current game mode to ensure continuity
    @Published var currentGameMode: GameMode = .story
    @Published var selectedCategory: GameCategory = .coding
    // Temporary storage for practice mode difficulty/type
    var pendingPracticeType: CipherType?
    
    // Track which daily challenge date is being played
    var playingDate: Date?
    
    enum HintState: Equatable {
        case none
        case clue
        case revealed(count: Int)
        
        var cost: Int {
            switch self {
            case .none: return 5
            case .clue: return 10
            case .revealed(let count):
                if count == 1 { return 30 }
                if count == 2 { return 50 }
                // Pattern: 80, 100, 120... starting from count 3 (going to 4th letter)
                // Wait, count 3 is currently revealed 3 letters. Next cost is for 4th letter.
                // User said "next 80".
                // If count=3, we want 80.
                return 80 + (count - 3) * 20
            }
        }
    }
    
    let timerManager = TimerManager()
    
    // Cache the cipher for the current level
    var currentCipher: Cipher?
    
    enum GameState {
        case menu
        case playing
        case paused
        case success
        case failed
        case calendar
        case categorySelect
    }
    
    init() {
        self.playerStats = UserDefaultsManager.shared.loadStats()
        // Determine if onboarding should be shown (first time users or explicit reset)
        if !playerStats.hasSeenOnboarding {
            self.isShowingOnboarding = true
        }
    }
    
    func completeOnboarding() {
        playerStats.hasSeenOnboarding = true
        isShowingOnboarding = false
        UserDefaultsManager.shared.saveStats(playerStats)
    }
    
    func showCalendar() {
        withAnimation {
            gameState = .calendar
        }
    }
    
    func closeCalendar() {
        withAnimation {
            gameState = .menu
        }
    }
    
    func showCategorySelection(mode: GameMode, preferredType: CipherType? = nil) {
        self.currentGameMode = mode
        self.pendingPracticeType = preferredType
        withAnimation {
            gameState = .categorySelect
        }
    }
    
    func startGame(mode: GameMode, preferredType: CipherType? = nil, levelIndex: Int? = nil, category: GameCategory? = nil) {
        // Set the current mode
        self.currentGameMode = mode
        if let cat = category {
            self.selectedCategory = cat
        }
        
        // Load level based on stats or mode
        // For story, use currentLevelIndex
        let targetIndex: Int
        if let index = levelIndex {
             targetIndex = index
        } else {
             targetIndex = (mode == .story) ? playerStats.currentLevelIndex : 0
        }
        
        // Ensure daily challenge logic
        var seed: Int? = nil
        if mode == .daily {
             if let date = playingDate {
                 seed = DailyChallengeManager.shared.seed(for: date)
             } else {
                 seed = DailyChallengeManager.shared.todaySeed
             }
        }
        
        loadLevel(index: targetIndex, mode: mode, preferredType: preferredType, seed: seed, category: self.selectedCategory)
        withAnimation {
            gameState = .playing
        }
    }
    
    func startDailyChallenge(date: Date? = nil) {
        let targetDate = date ?? Date()
        self.playingDate = targetDate
        startGame(mode: .daily)
    }
    
    func startPractice(difficulty: String) {
        var type: CipherType = .caesar
        // Hard Mission: Strictly Vigenere only
        if difficulty == "HARD" { type = .caesar }
        if difficulty == "DIFFICULT" { type = .vigenere }
        // For practice, show category selection first? Or directly start?
        // Let's assume for now we go through category selection for everything via showCategorySelection
        // But if called directly, we use default category.
        startGame(mode: .practice, preferredType: type)
    }

    func loadLevel(index: Int, mode: GameMode, preferredType: CipherType? = nil, seed: Int? = nil, category: GameCategory = .coding) {
        // Clear state BEFORE loading level to prevent UI glitch
        self.userInput = "" // Reset input
        self.attempts = 0 // Reset attempts
        self.feedbackMessage = nil
        self.hintState = .clue
        
        // Generate and set new level
        let level = PuzzleGenerator.shared.generateLevel(index: index, mode: mode, preferredType: preferredType, seed: seed, category: category)
        self.currentLevel = level
        self.currentCipher = CipherFactory.getCipher(for: level.cipherType)
        
        if let limit = level.timeLimit {
            timerManager.start(duration: limit)
        }
    }
    
    func submitAnswer() {
        guard let level = currentLevel else { return }
        
        if userInput.uppercased().trimmingCharacters(in: .whitespacesAndNewlines) == level.plaintext {
            // Success
            handleSuccess()
        } else {
            // Failure
            attempts += 1
            feedbackMessage = "Incorrect! Try again."
            // Play error sound (placeholder)
        }
    }
    
    private func handleSuccess() {
        guard let level = currentLevel else { return }
        
        // Calculate reward based on attempts
        let earnedCoins: Int
        let earnedXP: Int
        
        if attempts == 0 {
            earnedCoins = 50
            earnedXP = 50
        } else if attempts == 1 {
            earnedCoins = 35
            earnedXP = 30
        } else if attempts == 2 {
            earnedCoins = 20
            earnedXP = 15
        } else {
            earnedCoins = 10
            earnedXP = 5
        }
        
        playerStats.levelsCompleted += 1
        playerStats.experience += earnedXP
        
        self.lastEarnedCoins = earnedCoins
        self.lastEarnedXP = earnedXP
        
        // Handle Game Mode specifics
        if gameState == .playing {
             if currentGameMode == .story { 
                playerStats.currentLevelIndex += 1
             }
             
             // Daily Challenge Reward
             if level.title == "Daily Challenge" {
                  if let date = playingDate {
                      DailyChallengeManager.shared.markChallengeCompleted(for: date)
                  } else {
                      DailyChallengeManager.shared.markChallengeCompleted() // Fallback to today
                  }
                  playerStats.coins += earnedCoins // Dynamic reward
              } else {
                  playerStats.coins += earnedCoins
              }
        }
        UserDefaultsManager.shared.saveStats(playerStats)
        
        timerManager.stop()
        gameState = .success
    }
    
    func nextLevel() {
        if currentGameMode == .practice {
            // Check if we have a preferred type from current level to maintain difficulty
            let type = currentLevel?.cipherType
            // Increment level index
            let nextIndex = (currentLevel?.id ?? 0) + 1
            startGame(mode: .practice, preferredType: type, levelIndex: nextIndex, category: selectedCategory)
        } else {
             startGame(mode: currentGameMode, category: selectedCategory)
        }
    }
    
    func useHint() {
        let cost = hintState.cost
        guard playerStats.coins >= cost else {
            feedbackMessage = "Not enough coins!"
            return
        }
        
        // Stop if fully revealed (count >= plaintext length)
        if case .revealed(let count) = hintState, let level = currentLevel, count >= level.plaintext.count {
             return
        }
        
        playerStats.coins -= cost
        playerStats.hintsUsed += 1
        
        guard let level = currentLevel else { return }
        
        switch hintState {
        case .none:
            hintState = .clue
        case .clue:
            hintState = .revealed(count: 1)
            userInput = String(level.plaintext.prefix(1))
        case .revealed(let count):
             let newCount = count + 1
             hintState = .revealed(count: newCount)
             userInput = String(level.plaintext.prefix(newCount))
        }
    }
    
    func updateAgentName(_ newName: String) {
        playerStats.agentName = newName.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        UserDefaultsManager.shared.saveStats(playerStats)
    }
}
