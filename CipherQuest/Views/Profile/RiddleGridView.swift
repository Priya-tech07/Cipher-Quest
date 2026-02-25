
import SwiftUI

struct Riddle: Identifiable {
    let id: Int
    let question: String
    let answer: String
    let xpRequired: Int
    let label: String
}

struct RiddleGridView: View {
    @ObservedObject var viewModel: GameViewModel
    var level: Int // Added level parameter
    var onDismiss: () -> Void
    @EnvironmentObject var themeManager: ThemeManager
    
    @State private var selectedRiddle: Riddle?
    @State private var riddleInput: String = ""
    @State private var showFeedback = false
    @State private var feedbackMsg = ""
    @State private var showBadgeAward = false
    @State private var showCelebrationEmoji = false
    
    // Riddles Data based on Level
    var riddles: [Riddle] {
        if level == 2 {
            return [
                Riddle(id: 10005, question: "I am a network of servers that stores data remotely. What am I?", answer: "CLOUD", xpRequired: 500, label: "NETWORK"),
                Riddle(id: 10006, question: "I am the interface that allows applications to talk to each other. What am I?", answer: "API", xpRequired: 550, label: "CONNECT"),
                Riddle(id: 10007, question: "I am the tool that tracks changes in your source code. What am I?", answer: "GIT", xpRequired: 600, label: "VERSION"),
                Riddle(id: 10008, question: "I scramble data so only authorized parties can understand it. What am I?", answer: "ENCRYPTION", xpRequired: 650, label: "SECURITY")
            ]
        } else if level == 3 {
            return [
                Riddle(id: 10009, question: "I am the protocol that ensures secure data transfer over the web. What am I?", answer: "HTTPS", xpRequired: 1000, label: "PROTOCOL"),
                Riddle(id: 10010, question: "I am a unique string that identifies a specific device on a network. What am I?", answer: "IP", xpRequired: 1100, label: "ADDRESS"),
                Riddle(id: 10011, question: "I am the process of converting human-readable code into machine code. What am I?", answer: "COMPILATION", xpRequired: 1200, label: "SYSTEM"),
                Riddle(id: 10012, question: "I am a malicious program that replicates itself to spread to other computers. What am I?", answer: "WORM", xpRequired: 1300, label: "THREAT")
            ]
        } else if level == 4 {
            return [
                Riddle(id: 10013, question: "I am a cryptographic hash function used to verify data integrity. What am I?", answer: "SHA", xpRequired: 2000, label: "HASH"),
                Riddle(id: 10014, question: "I am a piece of code that provides a way to interact with a hardware device. What am I?", answer: "DRIVER", xpRequired: 2100, label: "HARDWARE"),
                Riddle(id: 10015, question: "I am the principle of giving users only the access they need for their job. What am I?", answer: "LEAST PRIVILEGE", xpRequired: 2200, label: "POLICY"),
                Riddle(id: 10016, question: "I am a decentralized ledger that records transactions across many computers. What am I?", answer: "BLOCKCHAIN", xpRequired: 2300, label: "LEDGER")
            ]
        } else if level == 5 {
            return [
                Riddle(id: 10017, question: "I am the foundational model that describes how network protocols interact. What am I?", answer: "OSI", xpRequired: 3000, label: "ARCHITECTURE"),
                Riddle(id: 10018, question: "I am a system designed to detect and block unauthorized access to a network. What am I?", answer: "IPS", xpRequired: 3200, label: "DEFENSE"),
                Riddle(id: 10019, question: "I am the mathematical foundation of modern computer science and logic. What am I?", answer: "BOOLEAN", xpRequired: 3400, label: "LOGIC"),
                Riddle(id: 10020, question: "I am the elusive goal of building systems that learn and adapt on their own. What am I?", answer: "AGI", xpRequired: 3600, label: "FUTURE")
            ]
        } else if level == 6 {
            return [
                Riddle(id: 10021, question: "I am the piece of equipment used by the batsman to hit the ball. What am I?", answer: "BAT", xpRequired: 4000, label: "EQUIPMENT"),
                Riddle(id: 10022, question: "I am the three wooden posts that the bowler tries to hit. What am I?", answer: "WICKET", xpRequired: 4100, label: "TARGET"),
                Riddle(id: 10023, question: "I am the official who makes decisions on the field. What am I?", answer: "UMPIRE", xpRequired: 4200, label: "OFFICIAL"),
                Riddle(id: 10024, question: "I am a delivery that bounces twice or more before reaching the batsman. What am I?", answer: "DEAD BALL", xpRequired: 4300, label: "DELIVERY")
            ]
        } else if level == 7 {
            return [
                Riddle(id: 10025, question: "I am the person who oversees the entire filmmaking process. What am I?", answer: "DIRECTOR", xpRequired: 5000, label: "LEADERSHIP"),
                Riddle(id: 10026, question: "I am the award given annually for excellence in cinematic achievements. What am I?", answer: "OSCAR", xpRequired: 5100, label: "AWARD"),
                Riddle(id: 10027, question: "I am the written text of a movie, including dialogue and actions. What am I?", answer: "SCRIPT", xpRequired: 5200, label: "WRITING"),
                Riddle(id: 10028, question: "I am a short preview of an upcoming movie. What am I?", answer: "TRAILER", xpRequired: 5300, label: "PREVIEW")
            ]
        } else if level == 8 {
            return [
                Riddle(id: 10029, question: "I am the ancient civilization known for building the Great Pyramids. Who am I?", answer: "EGYPT", xpRequired: 6000, label: "CIVILIZATION"),
                Riddle(id: 10030, question: "I am the document signed in 1215 that limited the power of the English king. What am I?", answer: "MAGNA CARTA", xpRequired: 6100, label: "DOCUMENT"),
                Riddle(id: 10031, question: "I am the leader of the Mongol Empire who conquered vast territories in Asia. Who am I?", answer: "GENGHIS KHAN", xpRequired: 6200, label: "LEADER"),
                Riddle(id: 10032, question: "I am the historical period between the fall of Rome and the Renaissance. What am I?", answer: "MIDDLE AGES", xpRequired: 6300, label: "PERIOD")
            ]
        } else if level == 9 {
            return [
                Riddle(id: 10033, question: "I am the largest continent on Earth by both land area and population. What am I?", answer: "ASIA", xpRequired: 7000, label: "CONTINENT"),
                Riddle(id: 10034, question: "I am the longest river in the world, flowing through northeastern Africa. What am I?", answer: "NILE", xpRequired: 7100, label: "RIVER"),
                Riddle(id: 10035, question: "I am the imaginary line that divides the Earth into Northern and Southern Hemispheres. What am I?", answer: "EQUATOR", xpRequired: 7200, label: "LINE"),
                Riddle(id: 10036, question: "I am the highest mountain in the world above sea level. What am I?", answer: "EVEREST", xpRequired: 7300, label: "MOUNTAIN")
            ]
        } else {
            // Level 1 Default
            return [
                Riddle(id: 10001, question: "I am the language that styles the web universe. What am I?", answer: "CSS", xpRequired: 0, label: "WEB"),
                Riddle(id: 10002, question: "I am a data structure where the last item in is the first one out. What am I?", answer: "STACK", xpRequired: 50, label: "LOGIC"),
                Riddle(id: 10003, question: "I am the integrated environment where you spend most of your coding hours. What am I?", answer: "IDE", xpRequired: 100, label: "TOOLS"),
                Riddle(id: 10004, question: "I am the heart of the operating system, managing everything. What am I?", answer: "KERNEL", xpRequired: 150, label: "SYSTEM")
            ]
        }
    }
    
    var body: some View {
        ZStack {
            Color.cryptoDarkBlue.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                // Header
                HStack {
                    BackButton(action: onDismiss)
                    Spacer()
                    Text("SECURE RIDDLES")
                        .font(.system(size: 18, weight: .black, design: .monospaced))
                        .foregroundColor(.cryptoGreen)
                    Spacer()
                    CoinView(amount: viewModel.playerStats.coins)
                        .scaleEffect(0.8)
                }
                .padding(.horizontal)
                .padding(.top, 10)
                
                Text("Decrypt all 4 sectors to assemble the Master Badge.")
                    .font(.caption)
                    .foregroundColor(.cryptoSubtext)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Spacer()
                
                // Puzzle Grid (2x2 Container)
                ZStack {
                     // Underlying Badge (The Reward)
                    if level == 1 {
                        DeveloperBadgeView()
                            .scaleEffect(1.5)
                            .frame(width: 300, height: 300)
                    } else if level == 2 {
                        SystemArchitectBadgeView()
                            .scaleEffect(1.5)
                            .frame(width: 300, height: 300)
                    } else if level == 3 {
                        CyberSentinelBadgeView()
                            .scaleEffect(1.5)
                            .frame(width: 300, height: 300)
                    } else if level == 4 {
                        SecurityMasterBadgeView()
                            .scaleEffect(1.5)
                            .frame(width: 300, height: 300)
                    } else if level == 5 {
                        GrandMasterBadgeView()
                            .scaleEffect(1.5)
                            .frame(width: 300, height: 300)
                    } else if level == 6 {
                        CricketBadgeView()
                            .scaleEffect(1.5)
                            .frame(width: 300, height: 300)
                    } else if level == 7 {
                        CinemaBadgeView()
                            .scaleEffect(1.5)
                            .frame(width: 300, height: 300)
                    } else if level == 8 {
                        HistoryBadgeView()
                            .scaleEffect(1.5)
                            .frame(width: 300, height: 300)
                    } else if level == 9 {
                        GeographyBadgeView()
                            .scaleEffect(1.5)
                            .frame(width: 300, height: 300)
                    }
                        
                    // Overlay Cover Grid
                    VStack(spacing: 0) {
                        HStack(spacing: 0) {
                            PuzzlePieceView(
                                riddle: riddles[0],
                                quadrant: .topLeft,
                                isUnlocked: viewModel.playerStats.experience >= riddles[0].xpRequired,
                                isCompleted: viewModel.playerStats.completedRiddles.contains(riddles[0].id),
                                action: { handleRiddleTap(riddles[0]) }
                            )
                            PuzzlePieceView(
                                riddle: riddles[1],
                                quadrant: .topRight,
                                isUnlocked: viewModel.playerStats.experience >= riddles[1].xpRequired,
                                isCompleted: viewModel.playerStats.completedRiddles.contains(riddles[1].id),
                                action: { handleRiddleTap(riddles[1]) }
                            )
                        }
                        HStack(spacing: 0) {
                            PuzzlePieceView(
                                riddle: riddles[2],
                                quadrant: .bottomLeft,
                                isUnlocked: viewModel.playerStats.experience >= riddles[2].xpRequired,
                                isCompleted: viewModel.playerStats.completedRiddles.contains(riddles[2].id),
                                action: { handleRiddleTap(riddles[2]) }
                            )
                            PuzzlePieceView(
                                riddle: riddles[3],
                                quadrant: .bottomRight,
                                isUnlocked: viewModel.playerStats.experience >= riddles[3].xpRequired,
                                isCompleted: viewModel.playerStats.completedRiddles.contains(riddles[3].id),
                                action: { handleRiddleTap(riddles[3]) }
                            )
                        }
                    }
                }
                .padding(4)
                .background(Color.cryptoNavy.opacity(0.3))
                .cornerRadius(20)
                .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 5)
                
                Spacer()
                
                if (level == 1 && viewModel.playerStats.hasDeveloperBadge) || (level == 2 && viewModel.playerStats.hasArchitectBadge) || (level == 3 && viewModel.playerStats.hasSentinelBadge) || (level == 4 && viewModel.playerStats.hasSecurityBadge) || (level == 5 && viewModel.playerStats.hasGrandMasterBadge) || (level == 6 && viewModel.playerStats.hasCricketBadge) || (level == 7 && viewModel.playerStats.hasCinemaBadge) || (level == 8 && viewModel.playerStats.hasHistoryBadge) || (level == 9 && viewModel.playerStats.hasGeographyBadge) {
                    let badgeName: String = {
                        switch level {
                        case 1: return "MASTER DEVELOPER"
                        case 2: return "SYSTEM ARCHITECT"
                        case 3: return "CYBER SENTINEL"
                        case 4: return "SECURITY MASTER"
                        case 5: return "GRAND MASTER"
                        case 6: return "CRICKET CHAMPION"
                        case 7: return "CINEMA BUFF"
                        case 8: return "HISTORY SCHOLAR"
                        case 9: return "GEOGRAPHY EXPLORER"
                        default: return ""
                        }
                    }()
                    Text("BADGE RECOVERED: \(badgeName)")
                        .font(.system(size: 12, weight: .bold, design: .monospaced))
                        .foregroundColor(.cryptoGreen)
                        .padding()
                        .background(Color.cryptoNavy.opacity(0.8))
                        .cornerRadius(10)
                }
            }
            // Mystery Popup Overlay
            if let riddle = selectedRiddle {
                mysteryBoxOverlay(for: riddle)
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
            
            // Completion Animation Overlay
            if showBadgeAward {
                badgeAwardOverlay
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
    }
    
    // Check if level is complete
    private var isLevelComplete: Bool {
        let levelRiddleIds = riddles.map { $0.id }
        return levelRiddleIds.allSatisfy { viewModel.playerStats.completedRiddles.contains($0) }
    }
    
    private func handleRiddleTap(_ riddle: Riddle) {
        if viewModel.playerStats.experience >= riddle.xpRequired {
            if !viewModel.playerStats.completedRiddles.contains(riddle.id) {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) { selectedRiddle = riddle }
                riddleInput = ""
            } else if isLevelComplete {
                // Allow replaying the celebration animation if level is complete
                withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) { showBadgeAward = true }
            }
        }
    }
    
    private func checkAnswer() {
        guard let riddle = selectedRiddle else { return }
        
        if riddleInput.trimmingCharacters(in: .whitespacesAndNewlines).uppercased() == riddle.answer {
            feedbackMsg = "ACCESS GRANTED: PIECE UNLOCKED"
            showFeedback = true
            
            // Update stats immediately (popup stays open)
             withAnimation {
                if !viewModel.playerStats.completedRiddles.contains(riddle.id) {
                    viewModel.playerStats.completedRiddles.append(riddle.id)
                    viewModel.playerStats.coins += 50
                    viewModel.playerStats.experience += 50
                    
                    // Check completion inside the same update cycle

                    // Simpler check: check if all current level riddles are done
                    let levelRiddleIds = riddles.map { $0.id }
                    let isLevelComplete = levelRiddleIds.allSatisfy { viewModel.playerStats.completedRiddles.contains($0) }
                    
                    if isLevelComplete {
                        if level == 1 && !viewModel.playerStats.hasDeveloperBadge {
                            viewModel.playerStats.hasDeveloperBadge = true
                            viewModel.playerStats.experience += 50
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { showBadgeAward = true }
                        } else if level == 2 && !viewModel.playerStats.hasArchitectBadge {
                            viewModel.playerStats.hasArchitectBadge = true
                            viewModel.playerStats.experience += 100
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { showBadgeAward = true }
                        } else if level == 3 && !viewModel.playerStats.hasSentinelBadge {
                            viewModel.playerStats.hasSentinelBadge = true
                            viewModel.playerStats.experience += 150
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { showBadgeAward = true }
                        } else if level == 4 && !viewModel.playerStats.hasSecurityBadge {
                            viewModel.playerStats.hasSecurityBadge = true
                            viewModel.playerStats.experience += 200
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { showBadgeAward = true }
                        } else if level == 5 && !viewModel.playerStats.hasGrandMasterBadge {
                            viewModel.playerStats.hasGrandMasterBadge = true
                            viewModel.playerStats.experience += 500
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { showBadgeAward = true }
                        } else if level == 6 && !viewModel.playerStats.hasCricketBadge {
                            viewModel.playerStats.hasCricketBadge = true
                            viewModel.playerStats.experience += 600
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { showBadgeAward = true }
                        } else if level == 7 && !viewModel.playerStats.hasCinemaBadge {
                            viewModel.playerStats.hasCinemaBadge = true
                            viewModel.playerStats.experience += 700
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { showBadgeAward = true }
                        } else if level == 8 && !viewModel.playerStats.hasHistoryBadge {
                            viewModel.playerStats.hasHistoryBadge = true
                            viewModel.playerStats.experience += 800
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { showBadgeAward = true }
                        } else if level == 9 && !viewModel.playerStats.hasGeographyBadge {
                            viewModel.playerStats.hasGeographyBadge = true
                            viewModel.playerStats.experience += 900
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { showBadgeAward = true }
                        }
                    }
                    UserDefaultsManager.shared.saveStats(viewModel.playerStats)
                }
            }
        } else {
            feedbackMsg = "ACCESS DENIED: INCORRECT"
            showFeedback = true
        }
    }
    
    private func mysteryBoxOverlay(for riddle: Riddle) -> some View {
        ZStack {
            Color.cryptoDarkBlue.edgesIgnoringSafeArea(.all)
                .onTapGesture { selectedRiddle = nil }
            
            if showFeedback && feedbackMsg.contains("GRANTED") {
                // Success / Reward View
                VStack(spacing: 20) {
                    // Success Icon
                    ZStack {
                        Circle()
                            .fill(Color.blue.opacity(0.1))
                            .frame(width: 100, height: 100)
                        Image(systemName: "lock.open.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.cryptoGreen)
                    }
                    
                    VStack(spacing: 8) {
                        Text("ACCESS GRANTED")
                            .font(.system(size: 22, weight: .black, design: .monospaced))
                            .foregroundColor(.cryptoGreen)
                        
                        Text("✨ Sector Decrypted ✨")
                            .font(.system(size: 12, weight: .bold, design: .monospaced))
                            .foregroundColor(.cryptoSubtext)
                    }
                    
                    VStack(spacing: 5) {
                        Text("DECRYPTED MESSAGE")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.cryptoSubtext)
                        
                        Text(riddle.answer)
                            .font(.system(size: 24, weight: .black, design: .monospaced))
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                    }
                    
                    // Reward Card
                    VStack(spacing: 10) {
                        Text("REWARD")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.gray)
                        
                        HStack(spacing: 30) {
                            VStack {
                                Image(systemName: "centsign.circle.fill")
                                    .foregroundColor(.yellow)
                                    .font(.title2)
                                Text("+50")
                                    .font(.system(size: 14, weight: .bold, design: .monospaced))
                            }
                            
                            Divider().frame(height: 30)
                            
                            VStack {
                                Image(systemName: "bolt.fill") // Corrected to Bolt
                                    .foregroundColor(.orange)
                                    .font(.title2)
                                Text("+50")
                                    .font(.system(size: 14, weight: .bold, design: .monospaced))
                            }
                        }
                    }
                    .padding()
                    .background(Color.white.opacity(0.05))
                    .cornerRadius(15)
                    
                    Button(action: {
                        withAnimation {
                            selectedRiddle = nil
                            showFeedback = false
                        }
                    }) {
                        Text("NEXT LEVEL")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.cryptoGreen)
                            .cornerRadius(12)
                    }
                    
                    Button("RETURN TO BASE") {
                        withAnimation {
                            selectedRiddle = nil
                            showFeedback = false
                            onDismiss()
                        }
                    }
                    .font(.caption)
                    .foregroundColor(.gray)
                }
                .padding(30)
                .background(Color.cryptoLightNavy)
                .cornerRadius(25)
                .padding(40)
                .shadow(radius: 20)
                
            } else {
                // Question / Input View
                VStack(spacing: 25) {
                    Text("MYSTERY BOX: \(riddle.label)")
                        .font(.system(size: 16, weight: .black, design: .monospaced))
                        .foregroundColor(.cryptoPurple)
                    
                    Image(systemName: "cube.box.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.cryptoGreen)
                        .padding()
                        .rotationEffect(.degrees(showFeedback ? 360 : 0))
                        .animation(showFeedback ? Animation.linear(duration: 1).repeatForever(autoreverses: false) : .default, value: showFeedback)
                    
                    Text(riddle.question)
                        .font(.headline)
                        .foregroundColor(.black) // Ensure readable on white background
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    TextField("ANSWER", text: $riddleInput)
                        .font(.system(size: 20, weight: .black, design: .monospaced))
                        .multilineTextAlignment(.center)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(12)
                        .foregroundColor(.black) // Ensure readable on white background
                        .accentColor(.cryptoGreen)
                        .autocapitalization(.allCharacters)
                        .disableAutocorrection(true)
                    
                    if showFeedback {
                        Text(feedbackMsg)
                            .font(.caption)
                            .foregroundColor(feedbackMsg.contains("GRANTED") ? .blue : .cryptoError)
                            .bold()
                    }
                    
                    Button(action: checkAnswer) {
                        Text("UNLOCK PIECE")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.cryptoGreen)
                            .cornerRadius(12)
                    }
                }
                .padding(30)
                .frame(maxWidth: 500) // Constrain width for iPad
                .background(Color.white)
                .cornerRadius(25)
                .padding(40)
                .shadow(radius: 20)
            }
        }
    }


private var badgeAwardOverlay: some View {
    ZStack {
        Color.cryptoDarkBlue.edgesIgnoringSafeArea(.all)
        
        VStack {
            Spacer()
            Text("🎉")
                .font(.system(size: 100))
                .shadow(radius: 10)
                .scaleEffect(showCelebrationEmoji ? 1 : 0.3)
                .opacity(showCelebrationEmoji ? 1 : 0)
                .animation(.spring(response: 0.5, dampingFraction: 0.6), value: showCelebrationEmoji)
        }
        .padding(.bottom, 20)
        .zIndex(4)
        .onAppear {
            showCelebrationEmoji = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation(.easeOut(duration: 0.5)) {
                    showCelebrationEmoji = false
                }
            }
        }
        
        ConfettiView()
            .allowsHitTesting(false)
            .zIndex(5)
        
        VStack(spacing: 30) {
            VStack(spacing: 8) {
                Text("SYSTEM INTEGRATION")
                    .font(.system(size: 16, weight: .black, design: .monospaced))
                    .foregroundColor(.cryptoSubtext)
                Text("COMPLETE")
                    .font(.system(size: 32, weight: .black, design: .monospaced))
                    .foregroundColor(.cryptoGreen)
            }
            
            if level == 1 {
                DeveloperBadgeView()
            } else if level == 2 {
                SystemArchitectBadgeView()
            } else if level == 3 {
                CyberSentinelBadgeView()
            } else if level == 4 {
                SecurityMasterBadgeView()
            } else if level == 5 {
                GrandMasterBadgeView()
            } else if level == 6 {
                CricketBadgeView()
            } else if level == 7 {
                CinemaBadgeView()
            } else if level == 8 {
                HistoryBadgeView()
            } else if level == 9 {
                GeographyBadgeView()
            }
            
            VStack(spacing: 12) {
                Text("MISSION SUCCESS")
                    .font(.system(size: 12, weight: .bold, design: .monospaced))
                    .foregroundColor(.cryptoSubtext)
                
                let badgeName: String = {
                    switch level {
                    case 1: return "MASTER DEVELOPER"
                    case 2: return "SYSTEM ARCHITECT"
                    case 3: return "CYBER SENTINEL"
                    case 4: return "SECURITY MASTER"
                    case 5: return "GRAND MASTER"
                    default: return ""
                    }
                }()
                Text(badgeName)
                    .font(.system(size: 24, weight: .black, design: .monospaced))
                    .foregroundColor(level == 5 ? .cryptoPurple : .cryptoText)
                    .multilineTextAlignment(.center)
                
                Text("BADGE ACQUIRED")
                    .font(.system(size: 14, weight: .black, design: .monospaced))
                    .foregroundColor(.cryptoGreen)
                    .padding(.top, 5)
            }
            
            Button("CONFIRM") {
                withAnimation {
                    showBadgeAward = false
                }
            }
            .padding(.horizontal, 40)
            .padding(.vertical, 15)
            .background(Color.cryptoGreen)
            .foregroundColor(.white)
            .cornerRadius(15)
        }
    }
}
}

enum Quadrant {
case topLeft, topRight, bottomLeft, bottomRight
}

struct PuzzlePieceView: View {
let riddle: Riddle
let quadrant: Quadrant
let isUnlocked: Bool
let isCompleted: Bool
let action: () -> Void

var body: some View {
    Button(action: action) {
        ZStack {
            // Back Face (Locked / Question)
            if !isCompleted {
                VStack {
                    Image(systemName: isUnlocked ? "questionmark" : "lock.fill")
                        .font(.largeTitle)
                        .foregroundColor(isUnlocked ? .cryptoGreen : .gray)
                    
                    Text(isUnlocked ? riddle.label : "\(riddle.xpRequired) XP")
                        .font(.system(size: 10, weight: .bold, design: .monospaced))
                        .foregroundColor(isUnlocked ? .cryptoText : .gray)
                        .padding(.top, 5)
                }
                .frame(width: 150, height: 150)
                .background(Color.cryptoNavy)
                .overlay(
                    Rectangle()
                        .stroke(Color.white.opacity(0.1), lineWidth: 0.5)
                )
                .transition(.opacity) // Fade out effect
            } else {
                // Front Face (Transparent to reveal badge)
                Color.clear
                    .frame(width: 150, height: 150)
                    .contentShape(Rectangle()) // Pass through taps if needed, or block them
            }
        }
        .animation(.easeInOut(duration: 0.6), value: isCompleted)
    }
    .disabled(!isUnlocked) // Only disable if locked. If completed, it should be enabled for replay tap.
    }
    
    func offsetForQuadrant(_ quadrant: Quadrant) -> CGSize {
        switch quadrant {
        case .topLeft: return CGSize(width: 0, height: 0)
        case .topRight: return CGSize(width: -150, height: 0)
        case .bottomLeft: return CGSize(width: 0, height: -150)
        case .bottomRight: return CGSize(width: -150, height: -150)
        }
    }
}
