
import Foundation

class PuzzleGenerator {
    static let shared = PuzzleGenerator()
    
    private init() {}
    
    func generateLevel(index: Int, mode: GameMode, preferredType: CipherType? = nil, seed: Int? = nil) -> Level {
        // Difficulty scaling
        var difficulty = min((index / 5) + 1, 5)
        
        let type: CipherType
        if let preferred = preferredType {
            type = preferred
            difficulty = type.difficulty // Override difficulty based on type for specific modes
        } else if mode == .daily {
            // Daily challenge logic
            // Use the seed to pick a type
            var generator =  seed != nil ? RandomNumberGeneratorWrapper(seed: seed!) : RandomNumberGeneratorWrapper(seed: 0)
            let types: [CipherType] = [.caesar, .vigenere, .playfair]
            type = types.randomElement(using: &generator) ?? .vigenere
            difficulty = 3 // Standardize daily difficulty or randomize it
        } else {
             // For Story Mode (easy level), use only Caesar
             type = .caesar
        }
        
        // Data source
        let data = PuzzleGenerator.puzzleData
        
        var generator: RandomNumberGenerator
        if let seed = seed {
            generator = RandomNumberGeneratorWrapper(seed: seed)
        } else {
            generator = SystemRandomNumberGenerator()
        }
        
        let (txt, hint): (String, String)
        if mode == .story {
            // Sequential selection for Story Mode to avoid repetition
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
                  indexForDaily = seedVal // Fallback
             }
             
             let selection = data[indexForDaily % data.count]
             txt = selection.0
             hint = selection.1
        } else {
            // Random selection for other modes
            let selection = data.randomElement(using: &generator)!
            txt = selection.0
            hint = selection.1
        }
        
        // Generate random key
        let key: String
        switch type {
        case .caesar:
            key = String(Int.random(in: 1...5, using: &generator))
        case .vigenere, .playfair:
            let keywords = ["SKY", "BLUE", "CODE", "MOON", "TECH", "DATA", "BYTE", "NIGHT", "STAR", "GRID"]
            key = keywords.randomElement(using: &generator) ?? "KEY"
        }
        
        return Level(
            id: index,
            title: mode == .daily ? "Daily Challenge" : "Level \(index + 1)",
            storyContext: mode == .daily ? "Solve today's mystery to keep your streak alive!" : "Decode the message to proceed.",
            difficulty: difficulty,
            cipherType: type,
            plaintext: txt,
            key: key,
            hint: hint,
            timeLimit: mode == .timeTrial ? 60.0 : nil,
            rewardCoins: mode == .daily ? 50 : 10 * difficulty
        )
    }

    private static let puzzleData: [(String, String)] = [
        ("SECRET", "Something you keep hidden from others."),
        ("SWIFT", "A powerful language from Apple."),
        ("APPLE", "A fruit and a tech giant."),
        ("CIPHER", "A secret way of writing."),
        ("CODING", "Writing instructions for computers."),
        ("FUTURE", "The time that is yet to come."),
        ("GALAXY", "A system of millions or billions of stars."),
        ("XCODE", "The IDE used to build this app."),
        ("DEBUG", "Identifying and removing errors."),
        ("SYNTAX", "The arrangement of words and phrases."),
        ("MEMORY", "Where computers store data."),
        ("STACK", "LIFO data structure."),
        ("QUEUE", "FIFO data structure."),
        ("BINARY", "A system using only 0 and 1."),
        ("LOGIC", "Reasoning conducted according to strict principles."),
        ("ALGORITHM", "A process or set of rules to be followed."),
        ("VECTOR", "A quantity having direction as well as magnitude."),
        ("MATRIX", "A rectangular array of numbers."),
        ("PIXEL", "The smallest unit of a digital image."),
        ("RENDER", "Generating an image from a model."),
        ("SHADER", "A program used to calculate rendering effects."),
        ("KERNEL", "The core of an operating system."),
        ("THREAD", "A sequence of programmed instructions."),
        ("PROCESS", "An instance of a computer program that is being executed."),
        ("NETWORK", "A group of interconnected computers."),
        ("SERVER", "A computer that provides data to other computers."),
        ("CLIENT", "A computer that requests data from a server."),
        ("ROUTER", "A device that forwards data packets between networks."),
        ("SWITCH", "A device that connects devices on a computer network."),
        ("MODEM", "A device that modulates and demodulates signals."),
        ("WIFI", "Wireless networking technology."),
        ("BLUETOOTH", "Short-range wireless technology."),
        ("FIREWALL", "A network security system."),
        ("MALWARE", "Software intentionally designed to cause damage."),
        ("VIRUS", "A type of malware that replicates itself."),
        ("TROJAN", "Malware that disguises itself as legitimate software."),
        ("WORM", "Malware that spreads across networks."),
        ("SPYWARE", "Malware that gathers information about a person."),
        ("ADWARE", "Software that automatically displays or downloads advertising material."),
        ("RANSOMWARE", "Malware that encrypts files and demands payment."),
        ("PHISHING", "The fraudulent practice of sending emails purporting to be from reputable companies."),
        ("ENCRYPTION", "The process of encoding information."),
        ("DECRYPTION", "The process of decoding information."),
        ("HASHING", "Generating a value from a string of text."),
        ("TOKEN", "A security device or code."),
        ("AUTH", "Short for authentication."),
        ("LOGIN", "The process of gaining access to a computer system."),
        ("PASSWORD", "A secret string of characters used for authentication."),
        ("BIO", "Short for biometrics."),
        ("KEY", "A piece of information used to encrypt or decrypt data."),
        ("CERT", "Short for certificate."),
        ("SSL", "Secure Sockets Layer."),
        ("TLS", "Transport Layer Security."),
        ("HTTPS", "Hypertext Protocol Secure."),
        ("VPN", "Virtual Private Network."),
        ("PROXY", "A server that acts as an intermediary."),
        ("IP", "Internet Protocol."),
        ("DNS", "Domain Name System."),
        ("URL", "Uniform Resource Locator."),
        ("HTML", "Hypertext Markup Language."),
        ("CSS", "Cascading Style Sheets."),
        ("JS", "JavaScript."),
        ("API", "Application Programming Interface."),
        ("SDK", "Software Development Kit."),
        ("IDE", "Integrated Development Environment."),
        ("GIT", "A distributed version control system."),
        ("REPO", "Short for repository."),
        ("COMMIT", "Save changes to a repository."),
        ("PUSH", "Upload local repository content to a remote repository."),
        ("PULL", "Fetch from and integrate with another repository or a local branch."),
        ("MERGE", "Join two or more development histories together."),
        ("BRANCH", "A parallel version of a repository."),
        ("CLONE", "Make a copy of a repository."),
        ("FORK", "A copy of a repository that you manage."),
        ("ISSUE", "A unit of work to accomplish an improvement in a system."),
        ("BUG", "An error, flaw, failure or fault in a computer program."),
        ("FIX", "A solution to a bug."),
        ("PATCH", "A set of changes to a computer program."),
        ("VERSION", "A unique state of a computer program."),
        ("RELEASE", "The distribution of a final version of an application."),
        ("BETA", "A pre-release version of software."),
        ("ALPHA", "An early version of software."),
        ("DEMO", "A demonstration of a product."),
        ("TRIAL", "A test of the performance, qualities, or suitability of someone or something."),
        ("USER", "A person who uses a computer or network service."),
        ("ADMIN", "Short for administrator."),
        ("ROOT", "The user name or account that by default has access to all commands and files."),
        ("GUEST", "A user account with limited privileges."),
        ("SYSTEM", "A set of things working together as parts of a mechanism or an interconnecting network."),
        ("DATA", "Facts and statistics collected together for reference or analysis."),
        ("INFO", "Short for information."),
        ("FILE", "A resource for storing information."),
        ("FOLDER", "A virtual container within a digital file system."),
        ("DISK", "A storage device."),
        ("DRIVE", "A device that stores data."),
        ("CLOUD", "The practice of using a network of remote servers hosted on the Internet to store, manage, and process data."),
        ("VIRTUAL", "Not physically existing but made to appear by software."),
        ("REALITY", "The world or the state of things as they actually exist."),
        ("AUGMENTED", "Having been made greater in size or value."),
        ("ROBOT", "A machine capable of carrying out a complex series of actions automatically."),
        ("AI", "Artificial Intelligence."),
        ("ML", "Machine Learning."),
        ("DL", "Deep Learning."),
        ("NN", "Neural Network."),
        ("NLP", "Natural Language Processing."),
        ("CV", "Computer Vision."),
        ("IOT", "Internet of Things."),
        ("SMART", "Having or showing a quick-witted intelligence."),
        ("HOME", "The place where one lives."),
        ("CITY", "A large town."),
        ("CAR", "A road vehicle."),
        ("PHONE", "A telephone."),
        ("WATCH", "A small timepiece worn typically on a strap on one's wrist."),
        ("GLASS", "A hard, brittle substance."),
        ("VR", "Virtual Reality."),
        ("AR", "Augmented Reality."),
        ("MR", "Mixed Reality."),
        ("XR", "Extended Reality."),
        ("GAME", "A form of play or sport."),
        ("PC", "Personal Computer."),
        ("CONSOLE", "A panel or unit accommodating a set of controls for electronic or mechanical equipment."),
        ("MOBILE", "Able to move or be moved freely or easily."),
        ("WEB", "The World Wide Web."),
        ("APP", "An application, especially as downloaded by a user to a mobile device."),
        ("COMET", "A celestial object consisting of a nucleus of ice and dust."),
        ("ASTEROID", "A small rocky body orbiting the sun."),
        ("NEBULA", "A giant cloud of dust and gas in space."),
        ("ORBIT", "The curved path of a celestial object around a star."),
        ("GRAVITY", "The force that attracts a body toward the center of the earth."),
        ("OZONE", "A layer in the earth's stratosphere."),
        ("QUASAR", "A massive and extremely remote celestial object."),
        ("PULSAR", "A highly magnetized rotating compact star."),
        ("ECLIPSE", "The obscuring of the light from one celestial body by another."),
        ("METEOR", "A small body of matter from outer space."),
        ("SOLAR", "Relating to or determined by the sun."),
        ("LUNAR", "Relating to or determined by the moon."),
        ("TELESCOPE", "An optical instrument designed to make distant objects appear nearer."),
        ("ROCKET", "A cylindrical projectile that can be propelled to a great height."),
        ("ASTRO", "Relating to the stars or celestial bodies."),
        ("COSMOS", "The universe seen as a well-ordered whole."),
        ("SPACE", "A continuous area or expanse which is free, available, or unoccupied."),
        ("STARDUST", "A magical or charismatic quality or feeling."),
        ("PLANET", "A celestial body moving in an elliptical orbit around a star."),
        ("CRATER", "A large, bowl-shaped cavity in the ground."),
        ("VOYAGER", "A person who goes on a long journey."),
        ("HORIZON", "The line at which the earth's surface and the sky appear to meet."),
        ("ZENITH", "The point in the sky directly above an observer."),
        ("NADIR", "The point on the celestial sphere directly below an observer."),
        ("APOLLO", "A program of spaceflights."),
        ("NASA", "National Aeronautics and Space Administration."),
        ("SPACESHIP", "A spacecraft, especially one controlled by a crew."),
        ("SATELITE", "A celestial body orbiting the earth or another planet."),
        ("COSMONAUT", "A Russian astronaut."),
        ("ASTRONAUT", "A person who is trained to travel in a spacecraft."),
        ("ALIEN", "A hypothetical or fictional being from another world."),
        ("UFO", "Unidentified Flying Object."),
        ("MARTIAN", "Relating to the planet Mars."),
        ("VENUS", "The second planet from the sun."),
        ("JUPITER", "The largest planet in the solar system."),
        ("SATURN", "The planet with rings."),
        ("NEPTUNE", "The eighth planet from the sun."),
        ("URANUS", "The seventh planet from the sun."),
        ("MERCURY", "The smallest planet in the solar system."),
        ("PLUTO", "A dwarf planet."),
        ("MILKYWAY", "The galaxy of which the solar system is a part."),
        ("ANDROMEDA", "A large spiral galaxy."),
        ("HUBBLE", "A space telescope."),
        ("SUPERNOVA", "A star that suddenly increases greatly in brightness."),
        ("BLACKHOLE", "A region of space having a gravitational field so intense."),
        ("SINGULARITY", "A point at which a function takes an infinite value."),
        ("WORMHOLE", "A hypothetical connection between widely separated regions of space-time."),
        ("LIGHTYEAR", "A unit of astronomical distance."),
        ("PARSEC", "A unit of distance used in astronomy."),
        ("TELEPORT", "Transport across space and time."),
        ("LASER", "Light Amplification by Stimulated Emission of Radiation."),
        ("QUANTUM", "The smallest amount of many forms of energy."),
        ("NANOBOT", "A tiny robot."),
        ("GENOME", "The haploid set of chromosomes in a gamete."),
        ("CLONE", "An exact genetic copy."),
        ("CYBORG", "A person whose physical abilities are extended beyond the normal human limitations."),
        ("MECH", "A large, piloted robot."),
        ("REPLICANT", "A bioengineered being."),
        ("ANDROID", "A robot with a human appearance."),
        ("GENETICS", "The study of heredity and the variation of inherited characteristics."),
        ("BIOME", "A large naturally occurring community of flora and fauna."),
        ("ECOSYSTEM", "A biological community of interacting organisms."),
        ("SPECIES", "A group of living organisms consisting of similar individuals."),
        ("EVOLUTION", "The process by which different kinds of living organisms are thought to have developed."),
        ("ADAPT", "Make suitable for a new use or purpose."),
        ("SURVIVE", "Continue to live or exist."),
        ("EXTINCT", "Having no living members."),
        ("FOSSIL", "The remains or impression of a prehistoric organism."),
        ("DINOSAUR", "A fossil reptile of the Mesozoic era."),
        ("REPTILE", "A vertebrate animal of a class that includes snakes."),
        ("MAMMAL", "A warm-blooded vertebrate animal."),
        ("AMPHIBIAN", "A cold-blooded vertebrate animal."),
        ("INSECT", "A small arthropod animal."),
        ("ARACHNID", "A member of a class that includes spiders."),
        ("PRIME", "A number divisible only by itself and one."),
        ("FIBONACCI", "A sequence of numbers."),
        ("FRACTAL", "A curve or geometric figure."),
        ("GEOMETRY", "The branch of mathematics concerned with the properties and relations of points."),
        ("ALGEBRA", "The part of mathematics in which letters and other general symbols are used."),
        ("CALCULUS", "The branch of mathematics that deals with the finding and properties of derivatives."),
        ("STATISTICS", "The practice or science of collecting and analyzing numerical data."),
        ("PROBABILITY", "The extent to which something is probable."),
        ("INFINITY", "The state or quality of being infinite."),
        ("ZERO", "The numerical symbol 0."),
        ("PI", "The ratio of a circle's circumference to its diameter."),
        ("GOLDENRATIO", "A mathematical ratio."),
        ("CHIROPTERA", "An order of animals."),
        ("MARSUPIALIA", "An infraclass of animals."),
        ("SIMIAN", "A member of the monkey or ape family."),
        ("PACHYDERM", "A member of the elephant, rhinoceros, or hippopotamus family."),
        ("PROBOSCIDEA", "An order of animals."),
        ("SIRENIA", "An order of animals."),
        ("XENARTHRA", "An order of animals."),
        ("AFROTHERIA", "A superorder of animals."),
        ("LAURASIATHERIA", "A superorder of animals."),
        ("EUARCHONTOGLIRES", "A superorder of animals."),
        ("ATLANTOGENATA", "A cohort of animals."),
        ("BOREOEUTHERIA", "A clade of animals."),
        ("EUTHERIA", "An infraclass of animals."),
        ("METATHERIA", "A clade of animals."),
        ("PROTOTHERIA", "A subclass of animals."),
        ("THERIA", "A subclass of animals."),
        ("VERTEBRATA", "A subphylum of animals."),
        ("INVERTEBRATA", "Animals without a backbone."),
        ("METAZOA", "Animals."),
        ("PROTOZOA", "Single-celled eukaryotic organisms."),
        ("BACTERIA", "Single-celled prokaryotic organisms."), 
        ("ANIMALIA", "A kingdom of organisms."),
        ("ALGAE", "A large, diverse group of photosynthetic organisms."),
        ("MOSS", "A small, flowerless green plant."),
        ("FERN", "A flowerless plant that has feathery or leafy fronds."),
        ("CONIFER", "A tree that bears cones."),
        ("FLOWER", "The seed-bearing part of a plant."),
        ("FRUIT", "The sweet and fleshy product of a tree."),
        ("SEED", "A flowering plant's unit of reproduction."),
        ("SPORE", "A minute, typically one-celled, reproductive unit."),
        ("POLLEN", "A fine powdery substance."),
        ("NECTAR", "A sugary fluid secreted by plants."),
        ("CHLOROPHYLL", "A green pigment."),
        ("PHOTOSYNTHESIS", "The process by which green plants and some other organisms use sunlight."),
        ("RESPIRATION", "The process of breathing."),
        ("TRANSPIRATION", "The process of water movement through a plant."),
        ("GERMINATION", "The process by which a plant grows from a seed."),
        ("POLLINATION", "The transfer of pollen."),
        ("FERTILIZATION", "The action or process of fertilizing an egg."),
        ("OSMOSIS", "The movement of water molecules."),
        ("DIFFUSION", "The movement of molecules."),
        ("ENZYME", "A substance produced by a living organism."),
        ("HORMONE", "A regulatory substance."),
        ("VITAMIN", "An organic compound."),
        ("MINERAL", "A solid inorganic substance."),
        ("PROTEIN", "A large biomolecule."),
        ("LIPID", "A fatty acid."),
        ("CARBOHYDRATE", "A biomolecule consisting of carbon, hydrogen, and oxygen."),
        ("NUCLEICACID", "A complex organic substance."),
        ("DNA", "Deoxyribonucleic acid."),
        ("RNA", "Ribonucleic acid."),
        ("ATP", "Adenosine triphosphate."),
        ("ADP", "Adenosine diphosphate."),

        ("NAD", "Nicotinamide adenine dinucleotide."),
        ("FAD", "Flavin adenine dinucleotide."),
        ("CELL", "The smallest unit of life."),
        ("NUCLEUS", "The central part of a cell."),
        ("ORGANELLE", "A specialized subunit within a cell."),
        ("MITOCHONDRIA", "The powerhouse of the cell."),
        ("RIBOSOME", "A cell structure that makes protein."),
        ("CHLOROPLAST", "An organelle in green plants."),
        ("VACUOLE", "A space or vesicle within the cytoplasm of a cell."),
        ("LYSOSOME", "An organelle in the cytoplasm of eukaryotic cells."),
        ("GOLGI", "An organelle in eukaryotic cells."),
        ("ER", "Endoplasmic reticulum."),
        ("CYTOPLASM", "The material within a living cell."),
        ("MEMBRANE", "A thin pliable sheet of material."),
        ("WALL", "A continuous vertical brick or stone structure."),
        ("TISSUE", "A group of similar cells."),
        ("ORGAN", "A part of an organism."),
        ("SYSTEM", "A set of organs."),
        ("ORGANISM", "An individual animal, plant, or single-celled life form."),
        ("POPULATION", "All the inhabitants of a particular town, area, or country."),
        ("COMMUNITY", "A group of people living in the same place."),
        ("ECOSYSTEM", "A biological community."),
        ("BIOSPHERE", "The regions of the surface, atmosphere, and hydrosphere of the earth."),
        ("GEOSPHERE", "The solid part of the earth."),
        ("HYDROSPHERE", "All the waters on the earth's surface."),
        ("ATMOSPHERE", "The envelope of gases surrounding the earth."),
        ("STRATOSPHERE", "The layer of the earth's atmosphere."),
        ("MESOSPHERE", "The region of the earth's atmosphere above the stratosphere."),
        ("THERMOSPHERE", "The region of the atmosphere above the mesosphere."),
        ("EXOSPHERE", "The outermost region of a planet's atmosphere."),
        ("TROPOSPHERE", "The lowest region of the atmosphere."),
        ("IONOSPHERE", "The layer of the earth's atmosphere that contains a high concentration of ions."),
        ("MAGNETOSPHERE", "The region surrounding the earth."),
        ("CRYOSPHERE", "The frozen water part of the Earth system."),
        ("ANTHROPOSPHERE", "The part of the environment that is made or modified by humans."),
        ("LITHOSPHERE", "The rigid outer part of the earth."),
        ("ASTHENOSPHERE", "The upper layer of the earth's mantle."),
        ("MANTLE", "The region of the earth's interior between the crust and the core."),
        ("CORE", "The central or most important part of something."),
        ("CRUST", "The outermost layer of a planet."),
        ("PLATE", "A massive, irregularly shaped slab of solid rock."),
        ("TECTONICS", "The branch of geology."),
        ("EARTHQUAKE", "A sudden and violent shaking of the ground."),
        ("VOLCANO", "A mountain or hill."),
        ("MOUNTAIN", "A large natural elevation of the earth's surface."),
        ("VALLEY", "A low area of land between hills or mountains."),
        ("CANYON", "A deep gorge."),
        ("PLATEAU", "An area of relatively level high ground."),
        ("PLAIN", "A large area of flat land."),
        ("DESERT", "A barren area of landscape."),
        ("FOREST", "A large area covered chiefly with trees."),
        ("JUNGLE", "An area of land overgrown with dense forest."),
        ("SAVANNA", "A grassy plain in tropical and subtropical regions."),
        ("TUNDRA", "A vast, flat, treeless Arctic region."),
        ("STEPPE", "A large area of flat unforested grassland."),
        ("PRAIRIE", "A large open area of grassland."),
        ("COAST", "The part of the land adjoining or near the ocean."),
        ("BEACH", "A pebbly or sandy shore."),
        ("ISLAND", "A piece of land surrounded by water."),
        ("PENINSULA", "A piece of land almost surrounded by water."),
        ("ARCHIPELAGO", "A group of islands."),
        ("OCEAN", "A very large expanse of sea."),
        ("SEA", "The expanse of salt water."),
        ("LAKE", "A large body of water surrounded by land."),
        ("RIVER", "A large natural stream of water."),
        ("STREAM", "A small, narrow river."),
        ("CREEK", "A stream, inlet, or channel."),
        ("POND", "A small body of still water."),
        ("SWAMP", "An area of low-lying, uncultivated ground."),
        ("MARSH", "An area of low-lying land."),
        ("BOG", "Wet muddy ground."),
        ("FEN", "A low and marshy or frequently flooded area of land."),
        ("DELTA", "A triangular tract of sediment."),
        ("ESTUARY", "The tidal mouth of a large river."),
        ("LAGOON", "A stretch of salt water."),
        ("REEF", "A ridge of jagged rock."),
        ("ICEBERG", "A large floating mass of ice."),
        ("GLACIER", "A slowly moving mass or river of ice."),
        ("FJORD", "A long, narrow, deep inlet of the sea."),
        ("GEYSER", "A hot spring."),
        ("SPRING", "A place where water or oil wells up."),
        ("WELL", "A shaft sunk into the ground."),
        ("DAM", "A barrier constructed to hold back water."),
        ("FARM", "An area of land and its buildings."),
        ("VILLAGE", "A group of houses and associated buildings."),
        ("TOWN", "An urban area."),
        ("CITY", "A large town."),
        ("METROPOLIS", "The capital or chief city of a country or region."),
        ("MEGACITY", "A very large city."),
        ("CAPITAL", "The most important city or town of a country."),
        ("NATION", "A large body of people."),
        ("COUNTRY", "A nation with its own government."),
        ("STATE", "A nation or territory."),
        ("COUNTY", "A political and administrative division."),
        ("PROVINCE", "A principal administrative division."),
        ("REGION", "An area or division."),
        ("CONTINENT", "Any of the world's main continuous expanses of land."),
        ("EUROPE", "A continent."),
        ("ASIA", "A continent."),
        ("AFRICA", "A continent."),
        ("NORTHAMERICA", "A continent."),
        ("SOUTHAMERICA", "A continent."),
        ("ANTARCTICA", "A continent."),
        ("OCEANIA", "A region."),
        ("AUSTRALIA", "A country and a continent."),
        ("GREENLAND", "The world's largest island."),
        ("MADAGASCAR", "An island country off the coast of East Africa."),
        ("ICELAND", "A Nordic island nation."),
        ("JAPAN", "An island country in East Asia."),
        ("INDONESIA", "A country in Southeast Asia."),
        ("PHILIPPINES", "An archipelagic country in Southeast Asia."),
        ("CUBA", "The largest island in the Caribbean."),
        ("HAITI", "A Caribbean country."),
        ("JAMAICA", "A Caribbean island nation."),
        ("TAIWAN", "An island in East Asia."),
        ("BORNEO", "The third-largest island in the world."),
        ("SUMATRA", "A large island in Indonesia."),
        ("HONSHU", "The largest and most populous island of Japan."),

        ("MINDANAO", "The second-largest island in the Philippines."),
        ("NEWGUINEA", "The second-largest island in the world."),
        ("TASMANIA", "An island state of Australia."),

        ("CYPRUS", "An island country in the eastern Mediterranean."),
        ("MALTA", "An island country in the central Mediterranean."),
        ("CRETE", "The largest and most populous of the Greek islands."),
        ("SICILY", "The largest island in the Mediterranean Sea."),
        ("SARDINIA", "The second-largest island in the Mediterranean Sea.")
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
