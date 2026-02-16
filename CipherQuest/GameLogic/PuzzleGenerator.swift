
import Foundation

class PuzzleGenerator {
    static let shared = PuzzleGenerator()
    
    private init() {}
    
    func generateLevel(index: Int, mode: GameMode, preferredType: CipherType? = nil, seed: Int? = nil, category: GameCategory = .coding) -> Level {
        // Difficulty scaling
        var difficulty = min((index / 5) + 1, 5)
        
        let type: CipherType
        if let preferred = preferredType {
            type = preferred
            difficulty = type.difficulty // Override difficulty based on type for specific modes
        } else if mode == .daily {
            // Daily challenge logic
            var generator =  seed != nil ? RandomNumberGeneratorWrapper(seed: seed!) : RandomNumberGeneratorWrapper(seed: 0)
            let types: [CipherType] = [.atbash, .caesar, .vigenere]
            type = types.randomElement(using: &generator) ?? .vigenere
            difficulty = 3 
        } else {
             type = .atbash
        }
        
        // Data source based on category
        let data: [(String, String)]
        switch category {
        case .coding: data = PuzzleGenerator.codingData
        case .cricket: data = PuzzleGenerator.cricketData
        case .cinema: data = PuzzleGenerator.cinemaData
        case .geography: data = PuzzleGenerator.geographyData
        case .history: data = PuzzleGenerator.historyData
        }
        
        var generator: RandomNumberGenerator
        if let seed = seed {
            generator = RandomNumberGeneratorWrapper(seed: seed)
        } else {
            generator = SystemRandomNumberGenerator()
        }
        
        let (txt, hint): (String, String)
        if mode == .story {
            let selection = data[index % data.count]
            txt = selection.0
            hint = selection.1
        } else if mode == .daily {
             let seedVal = seed ?? 0
             var indexForDaily = 0
             let s = String(seedVal)
             let fmt = DateFormatter()
             fmt.dateFormat = "yyyyMMdd"
             if let date = fmt.date(from: s) {
                 let referenceDate = fmt.date(from: "20240101")!
                 let diff = Calendar.current.dateComponents([.day], from: referenceDate, to: date).day ?? 0
                 indexForDaily = max(0, diff)
             } else {
                  indexForDaily = seedVal
             }
             
             // For daily, maybe mix categories or stick to one? Let's use coding for daily consistency for now, or rotate based on day?
             // Actually, let's just use the passed category if possible, or default to coding for Daily to ensure consistency for everyone.
             let dailyData = PuzzleGenerator.codingData 
             let selection = dailyData[indexForDaily % dailyData.count]
             txt = selection.0
             hint = selection.1
        } else {
            let selection = data.randomElement(using: &generator)!
            txt = selection.0
            hint = selection.1
        }
        
        // Generate random key
        let key: String
        switch type {
        case .atbash: key = "NOKEY"
        case .caesar: key = String(Int.random(in: 1...5, using: &generator))
        case .vigenere:
            let keywords = ["SKY", "BLUE", "CODE", "MOON", "TECH", "DATA", "BYTE", "NIGHT", "STAR", "GRID"]
            key = keywords.randomElement(using: &generator) ?? "KEY"
        }
        
        return Level(
            id: index,
            title: mode == .daily ? "Daily Challenge" : "Level \(index + 1)",
            storyContext: mode == .daily ? "Solve today's mystery!" : "Category: \(category.displayName)",
            difficulty: difficulty,
            cipherType: type,
            plaintext: txt,
            key: key,
            hint: hint,
            timeLimit: mode == .timeTrial ? 60.0 : nil,
            rewardCoins: mode == .daily ? 50 : 10 * difficulty
        )
    }

    private static let codingData: [(String, String)] = [
        ("SECRET", "Something you keep hidden from others."),
        ("SWIFT", "A powerful language from Apple."),
        ("APPLE", "A fruit and a tech giant."),
        ("CIPHER", "A secret way of writing."),
        ("CODING", "Writing instructions for computers."),
        ("FUTURE", "The time that is yet to come."),
        ("GALAXY", "A system of millions or billions of stars."),
        ("XCODE", "The IDE used to build this app."),
        ("DEBUG", "Identifying and removing errors."),
        ("OZONE", "A layer in the earth's stratosphere."),
        ("LINUX", "An open-source operating system."),
        ("PYTHON", "A popular programming language."),
        ("JAVA", "A class-based, object-oriented programming language."),
        ("HTML", "Hypertext Markup Language."),
        ("CSS", "Cascading Style Sheets."),
        ("REACT", "A JavaScript library for building user interfaces."),
        ("NODE", "JavaScript runtime built on Chrome's V8 engine."),
        ("DOCKER", "A platform for developing, shipping, and running applications."),
        ("GIT", "A distributed version control system."),
        ("AGILE", "A software development methodology."),
        ("SCRUM", "An agile process framework for managing complex knowledge work."),
        ("BUG", "An error, flaw, failure or fault in a computer program."),
        ("PATCH", "A set of changes to a computer program.")
    ]

    private static let cricketData: [(String, String)] = [
        ("WICKET", "Three wooden stumps."),
        ("STUMP", "One of the three vertical posts."),
        ("BAILS", "Small wooden pieces on top of stumps."),
        ("YORKER", "A ball bowled at the batsman's feet."),
        ("SIXER", "Hitting the ball over the boundary."),
        ("FOUR", "Hitting the ball to the boundary."),
        ("SPIN", "Bowling with rotation."),
        ("PACE", "Fast bowling."),
        ("OVER", "Six deliveries."),
        ("MAIDEN", "An over with no runs scored."),
        ("DUCK", "Out for zero runs."),
        ("ASHES", "Famous Test series between England and Australia."),
        ("BOUND", "Short for Boundary."),
        ("CATCH", "Dismissing a batsman by catching the ball."),
        ("DRIVE", "A type of shot played with a straight bat."),
        ("PULL", "A cross-batted shot."),
        ("HOOK", "A shot played to the leg side off a short ball."),
        ("CUT", "A cross-batted shot played to the off side."),
        ("SWEEP", "A cross-batted shot played to the leg side."),
        ("GLANCE", "A delicate shot played to the leg side."),
        ("FIELD", "The action of stopping the ball."),
        ("UMPIRE", "The official who enforces the rules."),
        ("PITCH", "The central strip of the cricket field."),
        ("CREASE", "White lines marking the batting and bowling areas.")
    ]

    private static let cinemaData: [(String, String)] = [
        ("ACTION", "A genre with fast-paced sequences."),
        ("DRAMA", "A genre reliant on emotional development."),
        ("COMEDY", "A genre intended to make the audience laugh."),
        ("HORROR", "A genre intended to frighten."),
        ("SCIFI", "Science fiction."),
        ("OSCAR", "A prestigious film award."),
        ("ACTOR", "A person who portrays a character."),
        ("DIRECT", "The person who oversees the making of a film."),
        ("SCRIPT", "The written text of a play or movie."),
        ("SCENE", "A sequence of continuous action."),
        ("SHOT", "A single take of a camera."),
        ("CUT", "A transition from one shot to another."),
        ("ROLL", "To start the camera."),
        ("EDIT", "To assemble the shots of a film."),
        ("SCORE", "The original music written for a film."),
        ("SET", "The scenery and props used in a film."),
        ("PROP", "An object used in a film."),
        ("STUNT", "A dangerous or difficult action."),
        ("CGI", "Computer Generated Imagery."),
        ("IMAX", "A high-resolution film format."),
        ("NOIR", "A style of film marked by a mood of pessimism."),
        ("INDIE", "Independent film."),
        ("BLOCK", "Short for Blockbuster.")
    ]
    
    private static let geographyData: [(String, String)] = [
        ("ATLAS", "A book of maps."),
        ("EQUATOR", "Imaginary line dividing the earth."),
        ("DESERT", "A dry, barren area of land."),
        ("OCEAN", "A very large expanse of sea."),
        ("CANYON", "A deep gorge."),
        ("DELTA", "A triangular tract of sediment."),
        ("GLACIER", "A slowly moving mass of ice."),
        ("JUNGLE", "Land with dense forest."),
        ("TUNDRA", "A vast, flat, treeless Arctic region."),
        ("VOLCANO", "A mountain with a crater."),
        ("SUMMIT", "The highest point of a hill."),
        ("RIVER", "A large natural stream of water."),
        ("ISLAND", "Land surrounded by water."),
        ("CAPITAL", "The most important city or town."),
        ("BORDER", "A line separating two countries."),
        ("LATITUDE", "Distance north or south of the equator."),
        ("CLIMATE", "Weather conditions prevailing in an area."),
        ("PLATEAU", "An area of relatively high ground."),
        ("VALLEY", "A low area of land between hills."),
        ("REEF", "A ridge of jagged rock.")
    ]
    
    private static let historyData: [(String, String)] = [
        ("EMPIRE", "An extensive group of states."),
        ("KINGDOM", "A country, state, or territory ruled by a king or queen."),
        ("PHARAOH", "A ruler in ancient Egypt."),
        ("KNIGHT", "A man who served his sovereign or lord."),
        ("CASTLE", "A large building fortified against attack."),
        ("Viking", "Scandinavian seafaring pirates."),
        ("SPARTAN", "A citizen of Sparta."),
        ("SAMURAI", "A member of a powerful military caste in feudal Japan."),
        ("DYNASTY", "A line of hereditary rulers."),
        ("TREATY", "A formally concluded and ratified agreement."),
        ("COLONY", "A country or area under the full or partial control of another country."),
        ("REVOLT", "Rise in rebellion."),
        ("RELIC", "An object surviving from an earlier time."),
        ("MYTH", "A traditional story."),
        ("LEGEND", "A traditional story sometimes regarded as historical."),
        ("ANCIENT", "Belonging to the very distant past."),
        ("TEMPLE", "A building devoted to the worship of a god."),
        ("TOMB", "A large vault for burying the dead."),
        ("SCROLL", "A roll of parchment."),
        ("RUINS", "The physical destruction or disintegration of something.")
    ]
}

// Helper for seeded randomness
struct RandomNumberGeneratorWrapper: RandomNumberGenerator {
    private var state: UInt64
    
    init(seed: Int) {
        self.state = UInt64(seed)
    }
    
    mutating func next() -> UInt64 {
        state = 6364136223846793005 &* state &+ 1442695040888963407
        return state
    }
}
