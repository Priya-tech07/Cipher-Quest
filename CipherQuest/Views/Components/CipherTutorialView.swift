
import SwiftUI

struct CipherTutorialView: View {
    let cipherType: CipherType
    @State private var currentStep = 0
    @Binding var isPresented: Bool
    
    // Tutorial Steps Data based on Cipher Type
    var steps: [TutorialStep] {
        switch cipherType {
        case .caesar:
            return [
                TutorialStep(title: "The Shift", description: "Imagine the alphabet as a wheel.", visual: .caesarWheel),
                TutorialStep(title: "Pick a Number", description: "Choose a shift value (e.g., 3).", visual: .caesarShift(3)),
                TutorialStep(title: "Encrypt", description: "A becomes D, B becomes E...", visual: .caesarEncrypt),
                TutorialStep(title: "Decrypt", description: "Shift back by the same amount.", visual: .caesarDecrypt)
            ]
        case .vigenere:
            return [
                TutorialStep(title: "The Keyword", description: "Choose a secret word (e.g., KEY).", visual: .vigenereKeyword),
                TutorialStep(title: "Align & Repeat", description: "Write the keyword under your message.", visual: .vigenereAlign),
                TutorialStep(title: "Add Values", description: "Add the letter values (A=0, B=1...).", visual: .vigenereAdd),
                TutorialStep(title: "Modulo 26", description: "Wrap around if the sum > 25.", visual: .vigenereMod)
            ]
        case .playfair:
            return [
                TutorialStep(title: "The 5x5 Grid", description: "Key: MONARCHY. First, we build the 5x5 grid with the key and remaining alphabet.", visual: .playfairGrid),
                TutorialStep(title: "Make Pairs", description: "Let's encrypt 'OMZKBV'. Split it into pairs: 'OM', 'ZK', and 'BV'.", visual: .playfairPairs),
                TutorialStep(title: "Rule 1: Same Row", description: "Pair 'OM' is in the same ROW. Shift RIGHT to find the new letters.", visual: .playfairRow),
                TutorialStep(title: "Rule 2: Same Column", description: "Pair 'ZK' is in the same COLUMN. Shift DOWN to find the new letters.", visual: .playfairCol),
                TutorialStep(title: "Rule 3: Rectangle", description: "Pair 'BV' forms a rectangle. Swap corners horizontally.", visual: .playfairRect),
                TutorialStep(title: "The Result", description: "Combine everything to get our encrypted message: 'NORTH'.", visual: .playfairResult),
                TutorialStep(title: "The Playfair Logic", description: "Think of it as a set of logical operations based on position.", visual: .playfairFormula)
            ]
        }
    }
    
    var body: some View {
        VStack(spacing: 20) {
            // Header
            HStack {
                Button(action: {
                    withAnimation { isPresented = false }
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(.cryptoGreen)
                }
                
                Spacer()
                
                Text(cipherType.rawValue.uppercased())
                    .font(.system(size: 18, weight: .black, design: .monospaced))
                    .foregroundColor(.cryptoGreen)
                
                Spacer()
                
                // Placeholder to balance
                Image(systemName: "chevron.left").opacity(0)
            }
            .padding(.horizontal)
            .padding(.bottom, 15)
            .padding(.top, 50)
            .background(Color.cryptoNavy)
            
            // Progress Bar
            ProgressView(value: Double(currentStep + 1), total: Double(steps.count))
                .accentColor(.cryptoPurple)
                .padding(.horizontal)
            
            Spacer()
            
            // Content
            VStack(spacing: 30) {
                Text(steps[currentStep].title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.cryptoText)
                
                // Dynamic Visual View
                TutorialVisualView(visualType: steps[currentStep].visual)
                    .frame(height: 320)
                    .transition(.scale)
                    .id(currentStep) // Force redraw for animation
                
                Text(steps[currentStep].description)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.cryptoSubtext)
                    .padding(.horizontal)
                    .transition(.opacity)
            }
            
            Spacer()
            
            // Controls
            VStack(spacing: 0) {
                Divider()
                
                HStack {
                    Button(action: {
                        if currentStep > 0 { withAnimation { currentStep -= 1 } }
                    }) {
                        Text("PREV")
                            .font(.system(size: 16, weight: .bold, design: .monospaced))
                            .foregroundColor(currentStep > 0 ? .cryptoSubtext : .gray.opacity(0.3))
                            .padding(.horizontal)
                    }
                    .disabled(currentStep == 0)
                    
                    Spacer()
                    
                    HStack(spacing: 5) {
                        ForEach(0..<steps.count, id: \.self) { index in
                            Circle()
                                .fill(index == currentStep ? Color.cryptoPurple : Color.gray.opacity(0.3))
                                .frame(width: 8, height: 8)
                        }
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        if currentStep < steps.count - 1 {
                            withAnimation { currentStep += 1 }
                        } else {
                            withAnimation { isPresented = false }
                        }
                    }) {
                        HStack {
                            Text(currentStep < steps.count - 1 ? "NEXT" : "DONE")
                            Image(systemName: "arrow.right")
                        }
                        .font(.system(size: 16, weight: .bold, design: .monospaced))
                        .foregroundColor(.white)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 24)
                        .background(Color.cryptoGreen)
                        .cornerRadius(25)
                        .shadow(color: .cryptoGreen.opacity(0.3), radius: 5, x: 0, y: 3)
                    }
                }
                .padding()
                .padding(.bottom, 30) // Add bottom padding for home indicator
                .background(Color.white)
            }
        }
        .background(Color.cryptoDarkBlue.edgesIgnoringSafeArea(.all))
    }
}

struct TutorialStep {
    let title: String
    let description: String
    let visual: TutorialVisualType
}

enum TutorialVisualType {
    case caesarWheel
    case caesarShift(Int)
    case caesarEncrypt
    case caesarDecrypt
    
    case vigenereKeyword
    case vigenereAlign
    case vigenereAdd
    case vigenereMod
    
    case playfairGrid
    case playfairPairs
    case playfairRow
    case playfairCol
    case playfairRect
    case playfairResult
    case playfairFormula
}

struct TutorialVisualView: View {
    let visualType: TutorialVisualType
    @State private var animate = false
    
    // Consistent Grid for Playfair examples
    let cellSize: CGFloat = 40
    let gridSpacing: CGFloat = 5
    let gridRows = [
        ["M","O","N","A","R"],
        ["C","H","Y","B","D"],
        ["E","F","G","I","K"],
        ["L","P","Q","S","T"], // S, T are in row 3 (0-indexed)
        ["U","V","W","X","Z"]
    ]
    
    // Helper to calculate exact center offset for any cell (row, col)
    // Grid Center is (2, 2) which corresponds to offset (0, 0)
    func getGridOffset(row: Int, col: Int) -> CGSize {
        let stride = cellSize + gridSpacing
        return CGSize(
            width: CGFloat(col - 2) * stride, // -2 to center around index 2
            height: CGFloat(row - 2) * stride
        )
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) { // Important: ZStack alignment center
                Color.clear // Ensure ZStack fills space
                
                switch visualType {
            // CAESAR
            case .caesarWheel:
                Circle()
                    .strokeBorder(Color.cryptoGreen, lineWidth: 3)
                    .frame(width: 150, height: 150)
                    .overlay(Text("A..Z").font(.largeTitle))
            case .caesarShift(_):
                 VStack {
                     Text("ABC...").font(.title)
                     Image(systemName: "arrow.down").foregroundColor(.cryptoPurple)
                     Text("DEF...").font(.title).foregroundColor(.cryptoPurple)
                         .offset(x: animate ? 10 : -10)
                 }
                 .onAppear { withAnimation(.easeInOut(duration: 1).repeatForever(autoreverses: true)) { animate = true } }
                 
            case .caesarEncrypt:
                HStack {
                    Text("A")
                        .font(.largeTitle)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                    Image(systemName: "arrow.right").foregroundColor(.cryptoGreen)
                    Text("D") // Shift 3
                        .font(.largeTitle)
                        .padding()
                        .background(Color.cryptoGreen.opacity(0.2))
                        .cornerRadius(10)
                        .scaleEffect(animate ? 1.2 : 1.0)
                }
                .onAppear { withAnimation(.spring().repeatForever(autoreverses: true)) { animate = true } }
                
            case .caesarDecrypt:
                 HStack {
                    Text("D")
                        .font(.largeTitle)
                        .padding()
                        .background(Color.cryptoGreen.opacity(0.2))
                        .cornerRadius(10)
                    Image(systemName: "arrow.right").foregroundColor(.cryptoError)
                    Text("A") // Shift -3
                        .font(.largeTitle)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                        .scaleEffect(animate ? 1.2 : 1.0)
                }
                .onAppear { withAnimation(.spring().repeatForever(autoreverses: true)) { animate = true } }

            // VIGENERE
            case .vigenereKeyword:
                Text("KEY")
                    .font(.system(size: 60, weight: .black, design: .monospaced))
                    .foregroundColor(.cryptoPurple)
                    .opacity(animate ? 1 : 0.3)
                    .onAppear { withAnimation(.easeIn(duration: 1).repeatForever()) { animate = true } }
                    
            case .vigenereAlign:
                VStack(spacing: 5) {
                    Text("HELLO")
                        .font(.title2).bold().kerning(5)
                    Text("KEYKE")
                        .font(.title2).foregroundColor(.cryptoPurple).kerning(5)
                }
                
            case .vigenereAdd:
                VStack {
                    Text("H (7) + K (10)")
                    Rectangle().frame(height: 1).foregroundColor(.gray)
                    Text("17 (R)").foregroundColor(.cryptoGreen).bold()
                }
                .font(.system(.title3, design: .monospaced))
                
            case .vigenereMod:
                Text("(25 + 5) % 26 = 4 (E)")
                     .font(.title2).bold()
                     .padding()
                     .background(Color.yellow.opacity(0.2))
                     .cornerRadius(10)

            // PLAYFAIR
            case .playfairGrid:
                VStack(spacing: 5) {
                    Text("KEY: MONARCHY").font(.headline).foregroundColor(.cryptoPurple)
                    ForEach(0..<5) { r in
                        HStack(spacing: 5) {
                            ForEach(0..<5) { c in
                                RoundedRectangle(cornerRadius: 3)
                                    .fill(
                                        (r == 0 || (r == 1 && c <= 2)) // Highlight keyword
                                        ? Color.cryptoPurple.opacity(animate ? 0.3 : 0.1)
                                        : Color.gray.opacity(0.1)
                                    )
                                    .frame(width: 40, height: 40)
                                    .overlay(Text(gridRows[r][c]).font(.headline).foregroundColor((r == 0 || (r == 1 && c <= 2)) ? .cryptoPurple : .primary))
                            }
                        }
                    }
                }
                .onAppear { withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) { animate = true } }
                
            case .playfairPairs:
                VStack(spacing: 20) {
                    Text("MESSAGE: OMZKBV").font(.title3).bold()
                    HStack(spacing: 15) {
                        VStack {
                            Text("OM").font(.title).bold().foregroundColor(.blue)
                            Text("Pair 1").font(.caption).foregroundColor(.gray)
                        }
                        VStack {
                            Text("ZK").font(.title).bold().foregroundColor(.blue)
                            Text("Pair 2").font(.caption).foregroundColor(.gray)
                        }
                        VStack {
                            Text("BV").font(.title).bold().foregroundColor(.blue)
                            Text("Pair 3").font(.caption).foregroundColor(.gray)
                        }
                    }
                    Text("Split into letter pairs.").font(.caption).italic().foregroundColor(.gray)
                }
                
            case .playfairRow:
                VStack {
                    ZStack {
                        VStack(spacing: gridSpacing) {
                             ForEach(0..<5) { r in
                                HStack(spacing: gridSpacing) {
                                    ForEach(0..<5) { c in
                                        let char = gridRows[r][c]
                                        let isSource = (r == 0 && (c == 0 || c == 1)) 
                                        let isTarget = (r == 0 && (c == 1 || c == 2))
                                        let isRelevant = (r == 0 && (c == 0 || c == 1 || c == 2))
                                        
                                        ZStack {
                                            Rectangle()
                                                .fill(
                                                    isTarget && animate ? Color.blue.opacity(0.8) : 
                                                    (isSource ? Color.blue.opacity(0.3) : Color.gray.opacity(0.1))
                                                )
                                                .frame(width: cellSize, height: cellSize)
                                                .cornerRadius(5)
                                            Text(char)
                                                .font(.system(size: 16, weight: .bold))
                                                .foregroundColor(isTarget && animate ? .white : (isSource ? .blue : .gray))
                                        }
                                        .opacity(isRelevant ? 1.0 : 0.2)
                                        .scaleEffect((isTarget && animate) ? 1.1 : (isRelevant ? 1.05 : 1.0))
                                    }
                                }
                            }
                        }
                        if animate {
                            Image(systemName: "arrow.right").font(.title).bold().foregroundColor(.blue)
                                .offset(getGridOffset(row: 0, col: 0))
                                .offset(x: 22.5)
                                .transition(.opacity.combined(with: .scale))
                            Image(systemName: "arrow.right").font(.title).bold().foregroundColor(.blue)
                                .offset(getGridOffset(row: 0, col: 1))
                                .offset(x: 22.5)
                                .transition(.opacity.combined(with: .scale))
                        }
                    }
                    VStack(spacing: 5) {
                        if !animate {
                            Text("Locate 'O' and 'M' in the same ROW.")
                                .font(.caption).foregroundColor(.gray)
                        } else {
                            Text("Move RIGHT → Result: 'NO'")
                                .font(.headline).bold().foregroundColor(.blue)
                        }
                    }
                    .frame(height: 50)
                }
                .task {
                    while !Task.isCancelled {
                        animate = false
                        try? await Task.sleep(nanoseconds: 1_500_000_000)
                        withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                            animate = true
                        }
                        try? await Task.sleep(nanoseconds: 3_000_000_000)
                    }
                }

            case .playfairCol:
                VStack {
                    ZStack {
                        VStack(spacing: gridSpacing) {
                             ForEach(0..<5) { r in
                                HStack(spacing: gridSpacing) {
                                    ForEach(0..<5) { c in
                                        let char = gridRows[r][c]
                                        let isSource = (c == 4 && (r == 4 || r == 2))
                                        let isTarget = (c == 4 && (r == 0 || r == 3))
                                        let isRelevant = isSource || isTarget
                                        ZStack {
                                            Rectangle()
                                                .fill(
                                                    isTarget && animate ? Color.blue.opacity(0.8) :
                                                    (isSource ? Color.blue.opacity(0.3) : Color.gray.opacity(0.1))
                                                )
                                                .frame(width: cellSize, height: cellSize)
                                                .cornerRadius(5)
                                            Text(char)
                                                .font(.system(size: 16, weight: .bold))
                                                .foregroundColor(isTarget && animate ? .white : (isSource ? .blue : .gray))
                                        }
                                        .opacity(isRelevant ? 1.0 : 0.2)
                                        .scaleEffect((isTarget && animate) ? 1.1 : (isRelevant ? 1.05 : 1.0))
                                    }
                                }
                            }
                        }
                        if animate {
                            Image(systemName: "arrow.down").font(.title).bold().foregroundColor(.blue)
                                .offset(getGridOffset(row: 4, col: 4))
                                .offset(y: 22.5)
                                .transition(.opacity)
                            Image(systemName: "arrow.down").font(.title).bold().foregroundColor(.blue)
                                .offset(getGridOffset(row: 2, col: 4))
                                .offset(y: 22.5)
                                .transition(.opacity)
                        }
                    }
                    VStack(spacing: 5) {
                        if !animate {
                             Text("Locate 'Z' and 'K' in the same COL.")
                                .font(.caption).foregroundColor(.gray)
                        } else {
                            Text("Move DOWN → Result: 'RT'")
                                .font(.headline).bold().foregroundColor(.blue)
                        }
                    }
                    .frame(height: 50)
                }
                .task {
                    while !Task.isCancelled {
                        animate = false
                        try? await Task.sleep(nanoseconds: 1_500_000_000)
                        withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                            animate = true
                        }
                        try? await Task.sleep(nanoseconds: 3_000_000_000)
                    }
                }

            case .playfairRect:
                VStack {
                    ZStack {
                        VStack(spacing: gridSpacing) {
                             ForEach(0..<5) { r in
                                HStack(spacing: gridSpacing) {
                                    ForEach(0..<5) { c in
                                        let char = gridRows[r][c]
                                        let isSource = (r == 1 && c == 3) || (r == 4 && c == 1)
                                        let isTarget = (r == 1 && c == 1) || (r == 4 && c == 3)
                                        let isRelevant = isSource || isTarget
                                        ZStack {
                                            Rectangle()
                                                .fill(
                                                    isTarget && animate ? Color.blue.opacity(0.8) :
                                                    (isSource ? Color.blue.opacity(0.3) : Color.gray.opacity(0.1))
                                                )
                                                .frame(width: cellSize, height: cellSize)
                                                .cornerRadius(5)
                                            Text(char)
                                                .font(.system(size: 16, weight: .bold))
                                                .foregroundColor(isTarget && animate ? .white : (isSource ? .blue : .gray))
                                        }
                                        .opacity(isRelevant ? 1.0 : 0.2)
                                        .scaleEffect((isTarget && animate) ? 1.1 : (isRelevant ? 1.05 : 1.0))
                                    }
                                }
                            }
                        }
                        Rectangle()
                            .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                            .foregroundColor(.blue.opacity(0.3))
                            .frame(width: (cellSize * 3) + (gridSpacing * 2), height: (cellSize * 4) + (gridSpacing * 3))
                            .offset(x: 0, y: 22.5)
                            .opacity(0.5)
                        if animate {
                            Image(systemName: "arrow.left").font(.title).bold().foregroundColor(.blue)
                                .offset(getGridOffset(row: 1, col: 3))
                                .offset(x: -45)
                                .transition(.opacity)
                            Image(systemName: "arrow.right").font(.title).bold().foregroundColor(.blue)
                                .offset(getGridOffset(row: 4, col: 1))
                                .offset(x: 45)
                                .transition(.opacity)
                        }
                    }
                    VStack(spacing: 5) {
                        if !animate {
                             Text("Locate 'B' and 'V'. Form a Rectangle.")
                                .font(.caption).foregroundColor(.gray)
                        } else {
                            Text("Swap Corners → Result: 'HX'")
                                .font(.headline).bold().foregroundColor(.blue)
                        }
                    }
                    .frame(height: 50)
                }
                .task {
                    while !Task.isCancelled {
                        animate = false
                        try? await Task.sleep(nanoseconds: 1_500_000_000)
                        withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                            animate = true
                        }
                        try? await Task.sleep(nanoseconds: 3_000_000_000)
                    }
                }
                
            case .playfairResult:
                VStack(spacing: 30) {
                    HStack(spacing: 20) {
                        VStack(spacing: 5) {
                            Text("OM").font(.title2).bold().foregroundColor(.gray)
                            Image(systemName: "arrow.down").font(.caption).foregroundColor(.gray)
                            Text("NO").font(.title2).bold().foregroundColor(.blue)
                        }
                        VStack(spacing: 5) {
                            Text("ZK").font(.title2).bold().foregroundColor(.gray)
                            Image(systemName: "arrow.down").font(.caption).foregroundColor(.gray)
                            Text("RT").font(.title2).bold().foregroundColor(.blue)
                        }
                        VStack(spacing: 5) {
                            Text("BV").font(.title2).bold().foregroundColor(.gray)
                            Image(systemName: "arrow.down").font(.caption).foregroundColor(.gray)
                            Text("HX").font(.title2).bold().foregroundColor(.blue)
                        }
                    }
                    if animate {
                        VStack(spacing: 5) {
                            Text("COMBINE THEM")
                                .font(.caption).bold().foregroundColor(.cryptoPurple)
                            HStack(spacing: 0) {
                                Text("N").bold(); Text("O").bold(); Text("R").bold(); Text("T").bold(); Text("H").bold()
                            }
                            .font(.largeTitle)
                            .foregroundColor(.blue)
                            .padding()
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(10)
                            .transition(.scale)
                            Text("Result: NORTH").font(.caption).foregroundColor(.gray).padding(.top, 5)
                        }
                    }
                }
                .onAppear { withAnimation(.spring().delay(1.0)) { animate = true } }
                
            case .playfairFormula:
                VStack(spacing: 20) {
                    RuleFormulaRow(rule: "ROW", logic: "Shift RIGHT (col + 1)", icon: "arrow.right.square.fill", color: .blue)
                    RuleFormulaRow(rule: "COLUMN", logic: "Shift DOWN (row + 1)", icon: "arrow.down.square.fill", color: .cryptoPurple)
                    RuleFormulaRow(rule: "RECTANGLE", logic: "Swap Corners (x₁, y₂)", icon: "rectangle.split.2x1.fill", color: .cryptoGreen)
                    Text("Always use Modulo 5 for wrap-around.")
                        .font(.system(size: 10, weight: .bold, design: .monospaced))
                        .foregroundColor(.cryptoSubtext)
                        .padding(.top, 10)
                }
                .padding()
                .background(Color.white.opacity(0.5))
                .cornerRadius(15)
                .onAppear { withAnimation(.spring()) { animate = true } }
            }
        }
    }
}
}

struct RuleFormulaRow: View {
    let rule: String
    let logic: String
    let icon: String
    let color: Color
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon).font(.title2).foregroundColor(color).frame(width: 40)
            VStack(alignment: .leading, spacing: 2) {
                Text(rule).font(.system(size: 12, weight: .black, design: .monospaced)).foregroundColor(color)
                Text(logic).font(.system(size: 14, weight: .bold, design: .monospaced)).foregroundColor(.cryptoText)
            }
            Spacer()
        }
        .padding(12).background(Color.white).cornerRadius(10).shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}
