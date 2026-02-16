
import Foundation

struct PlayerStats: Codable {
    var agentName: String = "ACTIVE AGENT"
    var coins: Int = 10
    var levelsCompleted: Int = 0
    var hintsUsed: Int = 0
    var currentLevelIndex: Int = 0
    var experience: Int = 0
    var completedRiddles: [Int] = []
    var hasDeveloperBadge: Bool = false
    var hasArchitectBadge: Bool = false
    var hasSentinelBadge: Bool = false
    var hasSecurityBadge: Bool = false
    var hasGrandMasterBadge: Bool = false

    
    enum CodingKeys: String, CodingKey {
        case agentName, coins, levelsCompleted, hintsUsed, currentLevelIndex, experience, completedRiddles, hasDeveloperBadge, hasArchitectBadge, hasSentinelBadge, hasSecurityBadge, hasGrandMasterBadge
    }
    
    init() {}
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        agentName = try container.decodeIfPresent(String.self, forKey: .agentName) ?? "ACTIVE AGENT"
        coins = try container.decodeIfPresent(Int.self, forKey: .coins) ?? 10
        levelsCompleted = try container.decodeIfPresent(Int.self, forKey: .levelsCompleted) ?? 0
        hintsUsed = try container.decodeIfPresent(Int.self, forKey: .hintsUsed) ?? 0
        currentLevelIndex = try container.decodeIfPresent(Int.self, forKey: .currentLevelIndex) ?? 0
        experience = try container.decodeIfPresent(Int.self, forKey: .experience) ?? 0
        completedRiddles = try container.decodeIfPresent([Int].self, forKey: .completedRiddles) ?? []
        hasDeveloperBadge = try container.decodeIfPresent(Bool.self, forKey: .hasDeveloperBadge) ?? false
        hasArchitectBadge = try container.decodeIfPresent(Bool.self, forKey: .hasArchitectBadge) ?? false
        hasSentinelBadge = try container.decodeIfPresent(Bool.self, forKey: .hasSentinelBadge) ?? false
        hasSecurityBadge = try container.decodeIfPresent(Bool.self, forKey: .hasSecurityBadge) ?? false
        hasGrandMasterBadge = try container.decodeIfPresent(Bool.self, forKey: .hasGrandMasterBadge) ?? false

    }
    
    func level() -> Int {
        return (experience / 50) + 1
    }
}

