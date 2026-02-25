
import SwiftUI

class GameViewModel: ObservableObject {
    @Published var currentLevel: Level?
    @Published var playerStats: PlayerStats
    @Published var gameState: GameState = .menu
    @Published var isShowingHowToSolve = false
    @Published var isShowingReference = false
    @Published var isShowingProfile = false
    @Published var isShowingRiddleView = false
    
    // Onboarding State
    @Published var isOnboarding = false
    @Published var currentOnboardingStep: OnboardingStep = .menuIntro

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
        
        // Backfill logic removed to prevent inflating riddle count for skipped levels
        // if self.playerStats.completedRiddles.isEmpty && self.playerStats.currentLevelIndex > 0 { ... }
        
        // Check if first launch
        if !UserDefaults.standard.bool(forKey: "hasCompletedOnboarding") {
            self.isOnboarding = true
            self.currentOnboardingStep = .menuIntro
        }
        
        // One-time fix for user who had their stats inflated by the backfill bug
        // They reported having solved only 1 riddle but seeing 6.
        if !UserDefaults.standard.bool(forKey: "hasFixedRiddleCount_v1") {
            // Identifying the specific bugged state (Level 7, 0-5 filled)
            let buggedState = Array(0..<6)
            if self.playerStats.currentLevelIndex == 6 && self.playerStats.completedRiddles == buggedState {
                print("DEBUG: Fixing inflated stats...")
                // Reset to 1 completed riddle (Level 2)
                self.playerStats.completedRiddles = [0]
                self.playerStats.currentLevelIndex = 1
                self.playerStats.levelsCompleted = 1
                UserDefaultsManager.shared.saveStats(self.playerStats)
            }
            UserDefaults.standard.set(true, forKey: "hasFixedRiddleCount_v1")
        }
        
        // Ensure any existing progress is reflected in badges
        checkAchievements()
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
        playerStats.completedRiddles.append(level.id)
        
        // Log Daily Activity
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let todayKey = formatter.string(from: Date())
        playerStats.dailyActivity[todayKey, default: 0] += 1
        
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
        
        // Check for new badges
        checkAchievements()
        
        timerManager.stop()
        gameState = .success
    }
    
    /// Scans player stats and awards badges based on specific riddle set completions
    func checkAchievements() {
        var statsChanged = false
        let completed = Set(playerStats.completedRiddles)
        
        // 1. Developer Badge: Riddles 10001-10004
        let devSet: Set<Int> = [10001, 10002, 10003, 10004]
        if !playerStats.hasDeveloperBadge && devSet.isSubset(of: completed) {
            playerStats.hasDeveloperBadge = true
            statsChanged = true
        }
        
        // 2. System Architect: Riddles 10005-10008
        let archSet: Set<Int> = [10005, 10006, 10007, 10008]
        if !playerStats.hasArchitectBadge && archSet.isSubset(of: completed) {
            playerStats.hasArchitectBadge = true
            statsChanged = true
        }
        
        // 3. Cyber Sentinel: Riddles 10009-10012
        let sentinelSet: Set<Int> = [10009, 10010, 10011, 10012]
        if !playerStats.hasSentinelBadge && sentinelSet.isSubset(of: completed) {
            playerStats.hasSentinelBadge = true
            statsChanged = true
        }
        
        // 4. Security Master: Riddles 10013-10016
        let securitySet: Set<Int> = [10013, 10014, 10015, 10016]
        if !playerStats.hasSecurityBadge && securitySet.isSubset(of: completed) {
            playerStats.hasSecurityBadge = true
            statsChanged = true
        }
        
        // 5. Grand Master: Riddles 10017-10020
        let grandMasterSet: Set<Int> = [10017, 10018, 10019, 10020]
        if !playerStats.hasGrandMasterBadge && grandMasterSet.isSubset(of: completed) {
            playerStats.hasGrandMasterBadge = true
            statsChanged = true
        }
        
        // 6. Cricket Champion: Riddles 10021-10024
        let cricketSet: Set<Int> = [10021, 10022, 10023, 10024]
        if !playerStats.hasCricketBadge && cricketSet.isSubset(of: completed) {
            playerStats.hasCricketBadge = true
            statsChanged = true
        }
        
        // 7. Cinema Buff: Riddles 10025-10028
        let cinemaSet: Set<Int> = [10025, 10026, 10027, 10028]
        if !playerStats.hasCinemaBadge && cinemaSet.isSubset(of: completed) {
            playerStats.hasCinemaBadge = true
            statsChanged = true
        }
        
        // 8. History Scholar: Riddles 10029-10032
        let historySet: Set<Int> = [10029, 10030, 10031, 10032]
        if !playerStats.hasHistoryBadge && historySet.isSubset(of: completed) {
            playerStats.hasHistoryBadge = true
            statsChanged = true
        }
        
        // 9. Geography Explorer: Riddles 10033-10036
        let geoSet: Set<Int> = [10033, 10034, 10035, 10036]
        if !playerStats.hasGeographyBadge && geoSet.isSubset(of: completed) {
            playerStats.hasGeographyBadge = true
            statsChanged = true
        }
        
        if statsChanged {
            UserDefaultsManager.shared.saveStats(playerStats)
            // Force UI update
            objectWillChange.send()
        }
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
    
    // MARK: - Onboarding Logic
    
    func nextOnboardingStep() {
        guard let currentIndex = OnboardingStep.allCases.firstIndex(of: currentOnboardingStep) else { return }
        let nextIndex = currentIndex + 1
        
        if nextIndex < OnboardingStep.allCases.count {
            let nextStep = OnboardingStep.allCases[nextIndex]
            
            // If next step is completed, finish up
            if nextStep == .completed {
                completeOnboarding()
            } else {
                withAnimation {
                    currentOnboardingStep = nextStep
                    // Handle side effects (e.g., navigation)
                    handleOnboardingSideEffects(step: nextStep)
                }
            }
        } else {
            completeOnboarding()
        }
    }
    
    private func handleOnboardingSideEffects(step: OnboardingStep) {
        switch step {
        case .profileCoins:
            isShowingProfile = true
        case .gameIntro:
            isShowingProfile = false
             // Start a practice game using Atbash for the tutorial
             // We need to ensure we are in a clean state
             if gameState != .playing {
                 // Force start a game with Atbash
                 // We'll use a specific tutorial level or just a random one. 
                 // For now, let's use Practice Mode with Atbash
                 startGame(mode: .practice, preferredType: .atbash)
             }
        default:
            break
        }
    }
    
    func skipOnboarding() {
        completeOnboarding()
    }
    
    private func completeOnboarding() {
        withAnimation(.easeInOut(duration: 0.6)) {
            isOnboarding = false
            currentOnboardingStep = .completed
            isShowingProfile = false
            gameState = .menu
        }
        
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
    }
}
