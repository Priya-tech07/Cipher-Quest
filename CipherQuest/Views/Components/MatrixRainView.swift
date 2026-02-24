import SwiftUI

struct MatrixRainView: View {
    var body: some View {
        GeometryReader { geometry in
            let columnWidth: CGFloat = 18
            let columns = Int(geometry.size.width / columnWidth)
            
            HStack(spacing: 0) {
                ForEach(0..<columns, id: \.self) { _ in
                    MatrixColumn(columnHeight: geometry.size.height)
                }
            }
        }
        .drawingGroup() 
    }
}

struct MatrixColumn: View {
    let columnHeight: CGFloat
    let characters = "ｱｲｳｴｵｶｷｸｹｺｻｼｽｾｿﾀﾁﾂﾃﾄﾅﾆﾇﾈﾉﾊﾋﾌﾍﾎﾏﾐﾑﾒﾓﾔﾕﾖﾗﾘﾙﾚﾛﾜﾝ1234567890ABCDEF"
    
    @State private var charList: [String] = []
    @State private var headIndex: Int = -10 // Start above screen
    @State private var maxRows: Int = 0
    @State private var speed: Double = Double.random(in: 0.05...0.15)
    
    var body: some View {
        VStack(spacing: 2) {
            ForEach(0..<maxRows, id: \.self) { row in
                Text(row < charList.count ? charList[row] : "")
                    .font(.system(size: 15, weight: .bold, design: .monospaced))
                    .foregroundColor(row == headIndex ? .white : .cryptoGreen)
                    .opacity(getOpacity(for: row))
                    .shadow(color: row == headIndex ? .white.opacity(0.8) : .clear, radius: 5)
            }
        }
        .onAppear {
            maxRows = Int(columnHeight / 17)
            charList = (0..<maxRows).map { _ in String(characters.randomElement()!) }
            startRain()
        }
    }
    
    func startRain() {
        Timer.scheduledTimer(withTimeInterval: speed, repeats: true) { timer in
            // Move head down
            headIndex += 1
            
            // Randomly flicker characters
            if Int.random(in: 0...10) > 8 {
                let randomIndex = Int.random(in: 0..<charList.count)
                charList[randomIndex] = String(characters.randomElement()!)
            }
            
            // Reset head if it goes off bottom
            if headIndex > maxRows + 20 {
                headIndex = -Int.random(in: 5...15)
                speed = Double.random(in: 0.05...0.15)
            }
        }
    }
    
    func getOpacity(for row: Int) -> Double {
        if row > headIndex || row < headIndex - 15 {
            return 0
        }
        let distance = Double(headIndex - row)
        return 1.0 - (distance / 15.0)
    }
}
