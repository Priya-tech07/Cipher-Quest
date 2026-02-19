
import SwiftUI

struct ConfettiPiece: Identifiable {
    let id = UUID()
    var x: CGFloat
    var y: CGFloat
    var color: Color
    var size: CGFloat
    var velocity: CGPoint
    var rotation: Double
    var rotationSpeed: Double
    var opacity: Double
}

struct ConfettiView: View {
    @State private var pieces: [ConfettiPiece] = []
    let colors: [Color] = [.red, .blue, .green, .yellow, .pink, .purple, .orange]
    let timer = Timer.publish(every: 0.016, on: .main, in: .common).autoconnect() // ~60 FPS
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(pieces) { piece in
                    Rectangle()
                        .fill(piece.color)
                        .frame(width: piece.size, height: piece.size * 0.6)
                        .rotationEffect(.degrees(piece.rotation))
                        .position(x: piece.x, y: piece.y)
                        .opacity(piece.opacity)
                }
            }
            .onAppear {
                createPopperBurst(in: geometry.size)
            }
            .onReceive(timer) { _ in
                updateConfetti(in: geometry.size)
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    private func createPopperBurst(in size: CGSize) {
        let startX = size.width / 2
        let startY = size.height - 50 // Near bottom
        
        for _ in 0...150 {
            // Angle: 0 is right, -90 is up, 180 is left.
            // Shoot UP in a wide cone: -120 (left-up) to -60 (right-up).
            let randomAngle = Double.random(in: -120...(-60)) * .pi / 180
            let speed = Double.random(in: 15...35)
            
            pieces.append(ConfettiPiece(
                x: startX,
                y: startY,
                color: colors.randomElement()!,
                size: CGFloat.random(in: 8...12),
                velocity: CGPoint(
                    x: cos(randomAngle) * speed,
                    y: sin(randomAngle) * speed
                ),
                rotation: Double.random(in: 0...360),
                rotationSpeed: Double.random(in: -10...10),
                opacity: 1.0
            ))
        }
    }
    
    private func updateConfetti(in size: CGSize) {
        for i in 0..<pieces.count {
            // Apply Velocity
            pieces[i].x += pieces[i].velocity.x
            pieces[i].y += pieces[i].velocity.y
            
            // Apply Gravity
            pieces[i].velocity.y += 0.8 // Gravity
            
            // Apply Air Resistance
            pieces[i].velocity.x *= 0.98
            pieces[i].velocity.y *= 0.98
            
            // Rotation
            pieces[i].rotation += pieces[i].rotationSpeed
            
            // Fade out
            if pieces[i].velocity.y > 0 { // Only fade when falling
                pieces[i].opacity -= 0.005
            }
        }
        
        // Remove off-screen particles
        pieces.removeAll { $0.y > size.height + 50 || $0.opacity <= 0 }
    }
}
