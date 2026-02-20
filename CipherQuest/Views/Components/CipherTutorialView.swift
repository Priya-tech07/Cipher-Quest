
import SwiftUI

struct CipherTutorialView: View {
    let cipherType: CipherType
    @State private var currentStep = 0
    @Binding var isPresented: Bool
    
    // Tutorial Steps Data based on Cipher Type
    var steps: [TutorialStep] {
        switch cipherType {
        case .atbash:
            return [
                TutorialStep(title: "The Reverse Map", description: "The first letter flips with the last.", visual: .atbashMapping),
                TutorialStep(title: "Symmetry", description: "A becomes Z, Z becomes A. It works both ways!", visual: .atbashMirror),
                TutorialStep(title: "Example", description: "HELLO becomes SVOOL.", visual: .atbashExample)
            ]
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
        }
    }
    
    var body: some View {
        VStack(spacing: 20) {
            // Header
            HStack {
                BackButton(action: {
                    withAnimation { isPresented = false }
                })

                
                Spacer()
                
                Text(cipherType.rawValue.uppercased())
                    .font(.system(size: 18, weight: .black, design: .monospaced))
                    .foregroundColor(.cryptoGreen)
                
                Spacer()
                
                // Placeholder to balance
                BackButton(action: {}).opacity(0)
            }
            .padding(.horizontal)
            .padding(.bottom, 15)
            .padding(.top, 65)
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
                .background(Color.cryptoDarkBlue)
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
    case atbashMapping
    case atbashMirror
    case atbashExample
    
    case caesarWheel
    case caesarShift(Int)
    case caesarEncrypt
    case caesarDecrypt
    
    case vigenereKeyword
    case vigenereAlign
    case vigenereAdd
    case vigenereMod
}

struct TutorialVisualView: View {
    let visualType: TutorialVisualType
    @State private var animate = false
    

    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) { // Important: ZStack alignment center
                Color.clear // Ensure ZStack fills space
                
                switch visualType {
            // ATBASH
            case .atbashMapping:
                VStack(spacing: 20) {
                    Text("Top: A B C D ... M").font(.headline)
                    Image(systemName: "arrow.up.arrow.down").font(.title).foregroundColor(.cryptoGreen)
                    Text("Bot: Z Y X W ... N").font(.headline)
                }.padding()
                
            case .atbashMirror:
                HStack(spacing: 30) {
                    VStack {
                        Text("A")
                        Image(systemName: "arrow.down")
                        Text("Z")
                    }
                    VStack {
                        Text("Z")
                        Image(systemName: "arrow.down")
                        Text("A")
                    }
                }
                .font(.largeTitle)
                .foregroundColor(.cryptoPurple)
                
            case .atbashExample:
                VStack(spacing: 10) {
                     Text("H  E  L  L  O")
                     Image(systemName: "arrow.down").foregroundColor(.gray)
                     Text("S  V  O  O  L").bold().foregroundColor(.cryptoGreen)
                }
                .font(.title)

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
            }
        }
    }
    }
}

