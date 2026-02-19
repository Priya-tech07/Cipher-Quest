
import SwiftUI

struct StatsView: View {
    @ObservedObject var viewModel: GameViewModel
    var onDismiss: () -> Void
    
    // Computed stats
    private var totalSolved: Int {
        viewModel.playerStats.completedRiddles.count
    }
    
    // Helper to calculate stats
    private func calculateStats() -> (easy: Int, hard: Int, expert: Int) {
        var easy = 0
        var hard = 0
        var expert = 0
        
        for id in viewModel.playerStats.completedRiddles {
            let difficulty = min((id / 5) + 1, 5)
            
            switch difficulty {
            case 1, 2:
                easy += 1
            case 3, 4:
                hard += 1
            case 5:
                expert += 1
            default:
                break
            }
        }
        
        return (easy, hard, expert)
    }

    // Helper to get last 7 days activity
    private func getLast7DaysActivity() -> [Double] {
        var activity: [Double] = []
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        for i in 0..<7 {
            if let date = calendar.date(byAdding: .day, value: -6 + i, to: Date()) {
                let key = formatter.string(from: date)
                let count = viewModel.playerStats.dailyActivity[key] ?? 0
                activity.append(Double(count))
            }
        }
        return activity
    }
    
    var body: some View {
        let stats = calculateStats()
        let activityData = getLast7DaysActivity()
        
        ZStack {
            Color.cryptoDarkBlue.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                // Header
                HStack {
                    Button(action: onDismiss) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.cryptoGreen)
                            .padding()
                    }
                    Spacer()
                    Text("MISSION STATS")
                        .font(.system(size: 20, weight: .black, design: .monospaced))
                        .foregroundColor(.cryptoText)
                    Spacer()
                    // Spacer to balance the back button
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.clear)
                        .padding()
                }
                .padding(.top, 50)
                
                ScrollView {
                    VStack(spacing: 25) {
                        // Activity Graph
                        VStack(alignment: .leading, spacing: 15) {
                            Text("DAILY STREAK")
                                .font(.system(size: 14, weight: .black, design: .monospaced))
                                .foregroundColor(.cryptoText)
                                .padding(.horizontal)
                            
                            // Line Graph Container
                            ZStack {
                                Color.cryptoLightNavy
                                
                                LineGraph(dataPoints: activityData)
                                .padding(.top, 20)
                                .padding(.bottom, 40) // Space for labels
                                .padding(.horizontal, 20)
                                
                                // X-Axis Labels
                                VStack {
                                    Spacer()
                                    HStack {
                                        Text("7 DAYS AGO") .frame(maxWidth: .infinity, alignment: .leading)
                                        Text("TODAY").frame(maxWidth: .infinity, alignment: .trailing)
                                    }
                                    .font(.system(size: 10, weight: .bold, design: .monospaced))
                                    .foregroundColor(.cryptoSubtext)
                                    .padding(.bottom, 10)
                                    .padding(.horizontal, 20)
                                }
                            }
                            .frame(height: 250)
                            .cornerRadius(20)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.cryptoGreen.opacity(0.3), lineWidth: 1)
                            )
                            .padding(.horizontal)
                        }
                        
                        // Breakdown Section
                        VStack(alignment: .leading, spacing: 15) {
                            Text("DIFFICULTY BREAKDOWN")
                                .font(.system(size: 14, weight: .black, design: .monospaced))
                                .foregroundColor(.cryptoText)
                                .padding(.horizontal)
                            
                            VStack(spacing: 15) {
                                StatRow(title: "EASY", count: stats.easy, color: .cryptoBlue, icon: "arrow.right.circle.fill")
                                StatRow(title: "HARD", count: stats.hard, color: .cryptoGreen, icon: "shield.righthalf.filled")
                                StatRow(title: "DIFFICULT", count: stats.expert, color: Color(hex: "2B4E72"), icon: "exclamationmark.triangle.fill")
                            }
                            .padding()
                            .background(Color.cryptoSurface.opacity(0.3))
                            .cornerRadius(15)
                            .padding(.horizontal)
                        }
                        
                        Spacer()
                    }
                    .padding(.bottom, 30)
                }
            }
        }
    }
}

// Custom Line Graph with Cubic Bezier Curves (Unchanged)
struct LineGraph: View {
    let dataPoints: [Double]
    @State private var isAnimated = false
    
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            let maxVal = (dataPoints.max() ?? 1) * 1.2
            // Ensure we have at least 2 points to draw a line, even if flat
            let effectivePoints = dataPoints.count > 1 ? dataPoints : [0.0, 0.0]
            
            let points = effectivePoints.enumerated().map { index, value in
                CGPoint(
                    x: width * CGFloat(index) / CGFloat(effectivePoints.count - 1),
                    y: height - (CGFloat(value) / CGFloat(maxVal > 0 ? maxVal : 1) * height)
                )
            }
            
            ZStack {
                // 1. Gradient Fill
                Path { path in
                    path.move(to: CGPoint(x: 0, y: height)) // Bottom Left
                    
                    if let first = points.first {
                        path.addLine(to: first)
                    }
                    
                    for i in 1..<points.count {
                        let current = points[i]
                        let previous = points[i-1]
                        let control1 = CGPoint(x: previous.x + (current.x - previous.x)/2, y: previous.y)
                        let control2 = CGPoint(x: previous.x + (current.x - previous.x)/2, y: current.y)
                        path.addCurve(to: current, control1: control1, control2: control2)
                    }
                    
                    path.addLine(to: CGPoint(x: width, y: height)) // Bottom Right
                    path.closeSubpath()
                }
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.cryptoGreen.opacity(0.4), Color.cryptoGreen.opacity(0.0)]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .opacity(isAnimated ? 1 : 0)
                .animation(.easeOut(duration: 0.8).delay(0.2), value: isAnimated)
                
                // 2. The Line Path
                Path { path in
                    if let first = points.first {
                        path.move(to: first)
                    }
                    
                    for i in 1..<points.count {
                        let current = points[i]
                        let previous = points[i-1]
                        let control1 = CGPoint(x: previous.x + (current.x - previous.x)/2, y: previous.y)
                        let control2 = CGPoint(x: previous.x + (current.x - previous.x)/2, y: current.y)
                        path.addCurve(to: current, control1: control1, control2: control2)
                    }
                }
                .trim(from: 0, to: isAnimated ? 1 : 0)
                .stroke(Color.cryptoGreen, style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
                .animation(.easeInOut(duration: 1.5), value: isAnimated)
                
                // 3. Data Points (Dots)
                ForEach(0..<points.count, id: \.self) { i in
                    Circle()
                        .fill(Color.cryptoGreen)
                        .frame(width: 8, height: 8)
                        .position(points[i])
                        .scaleEffect(isAnimated ? 1 : 0)
                        .animation(.spring().delay(Double(i) * 0.1 + 0.5), value: isAnimated)
                }
            }
        }
        .onAppear {
            isAnimated = true
        }
    }
}

struct StatRow: View {
    let title: String
    let count: Int
    let color: Color
    let icon: String
    
    var body: some View {
        HStack {
            HStack(spacing: 12) {
                Image(systemName: icon) 
                    .font(.title3)
                    .foregroundColor(.white)
                    .frame(width: 30)
                
                Text(title)
                    .font(.system(size: 16, weight: .bold, design: .monospaced))
                    .foregroundColor(.white)
            }
            
            Spacer()
            
            Text("\(count)")
                .font(.system(size: 20, weight: .black, design: .monospaced))
                .foregroundColor(.white)
        }
        .padding()
        .background(color)
        .cornerRadius(15)
    }
}
