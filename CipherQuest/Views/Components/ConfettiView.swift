
import SwiftUI

struct ConfettiPiece: Identifiable {
    let id = UUID()
    var x: CGFloat
    var y: CGFloat
    var color: Color
    var size: CGFloat
    var velocity: CGPoint
    var opacity: Double
}

struct ConfettiView: View {
    @State private var pieces: [ConfettiPiece] = []
    let colors: [Color] = [.cryptoGreen, .cryptoBlue, .cryptoPurple, .yellow, .pink, .orange]
    let timer = Timer.publish(every: 0.015, on: .main, in: .common).autoconnect()
    
    var body: some View {
        GeometryReader { _ in // Just to ensure it fills space
            ZStack {
                ForEach(pieces) { piece in
                    Rectangle()
                        .fill(piece.color)
                        .frame(width: piece.size, height: piece.size * 1.2)
                        .position(x: piece.x, y: piece.y)
                        .opacity(piece.opacity)
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            createTopBurst()
        }
        .onReceive(timer) { _ in
            updateConfetti()
        }
    }
    
    private func createTopBurst() {
        let width = UIScreen.main.bounds.width
        
        for _ in 0...100 {
            pieces.append(ConfettiPiece(
                x: CGFloat.random(in: 0...width),
                y: -20, // Start just off-screen at the top
                color: colors.randomElement()!,
                size: CGFloat.random(in: 8...14),
                velocity: CGPoint(
                    x: CGFloat.random(in: -5...5),
                    y: CGFloat.random(in: 15...30) // Fast downward pop
                ),
                opacity: 1.0
            ))
        }
    }
    
    private func updateConfetti() {
        for i in 0..<pieces.count {
            pieces[i].x += pieces[i].velocity.x
            pieces[i].y += pieces[i].velocity.y
            pieces[i].velocity.y *= 0.96 // Slight air resistance
            pieces[i].opacity -= 0.015 // Slower fade as they fall
        }
        pieces.removeAll { $0.opacity <= 0 || $0.y > UIScreen.main.bounds.height }
    }
}
