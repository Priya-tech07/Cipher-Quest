import SwiftUI

// MARK: - CalendarView

struct CalendarView: View {
    @ObservedObject var viewModel: GameViewModel
    
    private let days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    private let columns = Array(repeating: GridItem(.flexible()), count: 7)
    
    @State private var currentMonth: Date = Date()
    @State private var monthChangeDirection: Int = 0 
    
    var body: some View {
        GeometryReader { geometry in
            let isIPad = geometry.size.width > 600
            let horizontalPadding: CGFloat = isIPad ? 60 : 20
            let availableWidth = geometry.size.width - (horizontalPadding * 2)
            // 7 columns, plus spacing
            let spacing: CGFloat = isIPad ? 20 : 10
            let daySize = (availableWidth - (spacing * 6)) / 7
            
            VStack(spacing: isIPad ? 30 : 20) {
                // Header
                ZStack {
                    HStack(spacing: 8) {
                        Menu {
                            ForEach(1...12, id: \.self) { index in
                                Button(Calendar.current.monthSymbols[index - 1]) {
                                    setMonth(index)
                                }
                            }
                        } label: {
                            Text(currentMonthName())
                                .font(.system(size: isIPad ? 32 : 20, weight: .bold, design: .monospaced))
                                .foregroundColor(.cryptoText)
                        }
                        
                        Menu {
                            ForEach(2022...2030, id: \.self) { year in
                                Button(String(year)) {
                                    setYear(year)
                                }
                            }
                        } label: {
                            Text(currentYearString())
                                .font(.system(size: isIPad ? 32 : 20, weight: .bold, design: .monospaced))
                                .foregroundColor(.cryptoText)
                        }
                    }
                    
                    HStack {
                        BackButton(action: { viewModel.closeCalendar() })
                        Spacer()
                        
                        HStack(spacing: 12) {
                            Button {
                                changeMonth(by: -1)
                            } label: {
                                Image(systemName: "chevron.left.circle")
                                    .font(isIPad ? .largeTitle : .title2)
                                    .foregroundColor(.cryptoSubtext)
                            }
                            
                            Button {
                                changeMonth(by: 1)
                            } label: {
                                Image(systemName: "chevron.right.circle")
                                    .font(isIPad ? .largeTitle : .title2)
                                    .foregroundColor(.cryptoSubtext)
                            }
                        }
                    }
                }
                .padding(.horizontal, horizontalPadding)
                .padding(.top, isIPad ? 50 : 70)
                
                // Days of Week
                HStack(spacing: spacing) {
                    ForEach(days, id: \.self) { day in
                        Text(day)
                            .font(isIPad ? .title3 : .caption)
                            .fontWeight(.bold)
                            .foregroundColor(.cryptoSubtext)
                            .frame(width: daySize)
                    }
                }
                .padding(.horizontal, horizontalPadding)
                
                // Calendar Grid - Non-Lazy for instant rendering
                VStack(spacing: spacing) {
                    let items = daysInMonth()
                    let rows = Int(ceil(Double(items.count) / 7.0))
                    
                    ForEach(0..<rows, id: \.self) { row in
                        HStack(spacing: spacing) {
                            ForEach(0..<7, id: \.self) { column in
                                let index = row * 7 + column
                                if index < items.count {
                                    let item = items[index]
                                    if let date = item.date {
                                        DayCell(date: date, viewModel: viewModel, size: daySize, isIPad: isIPad)
                                    } else {
                                        Rectangle()
                                            .foregroundColor(.clear)
                                            .frame(width: daySize, height: daySize)
                                    }
                                } else {
                                    Rectangle()
                                        .foregroundColor(.clear)
                                        .frame(width: daySize, height: daySize)
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, horizontalPadding)
                .id(currentMonth)
                .transition(gridTransition)
                
                Spacer()
                
                // Stats
                HStack(spacing: 30) {
                    Spacer()
                    VStack {
                        Text("\(DailyChallengeManager.shared.currentStreak)")
                            .font(isIPad ? .system(size: 48, weight: .bold) : .title)
                            .fontWeight(.bold)
                            .foregroundColor(.cryptoGreen)
                        Text("Day Streak")
                            .font(isIPad ? .title3 : .caption)
                            .foregroundColor(.cryptoSubtext)
                    }
                    .frame(maxWidth: .infinity)
                    
                    VStack {
                        Image(systemName: "checkmark.seal.fill")
                            .font(isIPad ? .system(size: 40) : .title)
                            .foregroundColor(.cryptoBlue)
                        Text("Completed")
                            .font(isIPad ? .title3 : .caption)
                            .foregroundColor(.cryptoSubtext)
                    }
                    .frame(maxWidth: .infinity)
                    Spacer()
                }
                .padding(isIPad ? 30 : 15)
                .background(Color.cryptoNavy)
                .cornerRadius(15)
                .padding(.horizontal, horizontalPadding)
                .padding(.bottom, 30)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.cryptoDarkBlue)
        .edgesIgnoringSafeArea(.all)
    }
    
    // MARK: - Grid transition (identity on first appear, directional on month change)
    
    private var gridTransition: AnyTransition {
        if monthChangeDirection == 0 {
            return .identity
        }
        return monthChangeDirection > 0
            ? AnyTransition.asymmetric(
                insertion: .move(edge: .trailing).combined(with: .opacity),
                removal: .move(edge: .leading).combined(with: .opacity)
            )
            : AnyTransition.asymmetric(
                insertion: .move(edge: .leading).combined(with: .opacity),
                removal: .move(edge: .trailing).combined(with: .opacity)
            )
    }
    
    // MARK: - Navigation helpers
    
    func changeMonth(by value: Int) {
        guard let newMonth = Calendar.current.date(byAdding: .month, value: value, to: currentMonth) else { return }
        monthChangeDirection = (value >= 0) ? 1 : -1
        withAnimation(.spring(response: 0.45, dampingFraction: 0.8)) {
            currentMonth = newMonth
        }
    }
    
    func setMonth(_ monthIndex: Int) {
        var components = Calendar.current.dateComponents([.year, .month, .day], from: currentMonth)
        components.month = monthIndex
        if let newDate = Calendar.current.date(from: components) {
            // --- FIX: compare at .month granularity to avoid day-component flips ---
            let cmp = Calendar.current.compare(newDate, to: currentMonth, toGranularity: .month)
            switch cmp {
            case .orderedAscending:
                monthChangeDirection = -1
            case .orderedDescending:
                monthChangeDirection = 1
            default:
                monthChangeDirection = 0
            }
            withAnimation(.spring(response: 0.45, dampingFraction: 0.8)) {
                currentMonth = newDate
            }
        }
    }
    
    func setYear(_ year: Int) {
        var components = Calendar.current.dateComponents([.year, .month, .day], from: currentMonth)
        components.year = year
        if let newDate = Calendar.current.date(from: components) {
            // --- FIX: compare at .month granularity to avoid day-component flips ---
            let cmp = Calendar.current.compare(newDate, to: currentMonth, toGranularity: .month)
            switch cmp {
            case .orderedAscending:
                monthChangeDirection = -1
            case .orderedDescending:
                monthChangeDirection = 1
            default:
                monthChangeDirection = 0
            }
            withAnimation(.spring(response: 0.45, dampingFraction: 0.8)) {
                currentMonth = newDate
            }
        }
    }
    
    // MARK: - Formatters
    
    func currentMonthName() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter.string(from: currentMonth)
    }
    
    func currentYearString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter.string(from: currentMonth)
    }
    
    // MARK: - Days
    
    struct DayItem: Identifiable, Hashable {
        let id = UUID()
        let date: Date?
    }
    
    func daysInMonth() -> [DayItem] {
        let calendar = Calendar.current
        guard let range = calendar.range(of: .day, in: .month, for: currentMonth) else { return [] }
        let numDays = range.count
        
        let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: currentMonth))!
        let firstWeekday = calendar.component(.weekday, from: firstDayOfMonth)
        
        var items: [DayItem] = []
        for _ in 0..<(firstWeekday - 1) {
            items.append(DayItem(date: nil))
        }
        for day in 1...numDays {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: firstDayOfMonth) {
                items.append(DayItem(date: date))
            }
        }
        while items.count % 7 != 0 {
            items.append(DayItem(date: nil))
        }
        return items
    }
}

// MARK: - DayCell

struct DayCell: View {
    var date: Date
    @ObservedObject var viewModel: GameViewModel
    var size: CGFloat
    var isIPad: Bool
    
    private let calendar = Calendar.current
    
    // Shared formatter
    private static let keyFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyyMMdd"
        return f
    }()
    
    var isToday: Bool {
        calendar.isDateInToday(date)
    }
    
    var isFuture: Bool {
        let todayStart = calendar.startOfDay(for: Date())
        let dateStart = calendar.startOfDay(for: date)
        return dateStart > todayStart
    }
    
    var isCompleted: Bool {
        let seed = Int(Self.keyFormatter.string(from: date)) ?? 0
        return DailyChallengeManager.shared.completedDates.contains(seed)
    }
    
    var body: some View {
        Button(action: {
            if !isCompleted && !isFuture {
                viewModel.startDailyChallenge(date: date)
            }
        }) {
            VStack {
                Text("\(calendar.component(.day, from: date))")
                    .font(.system(size: isIPad ? 24 : 16, weight: .bold))
                    .foregroundColor(textColor)
            }
            .frame(width: size, height: size)
            .background(backgroundColor)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(borderColor, lineWidth: isIPad ? 4 : 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(isFuture || isCompleted)
        .opacity(isFuture ? 0.35 : 1.0)
    }
    
    var backgroundColor: Color {
        if isToday {
            return .cryptoGreen
        } else if isCompleted {
            if calendar.isDateInYesterday(date) {
                return .cryptoBlue.opacity(0.5)
            } else {
                return .cryptoBlue
            }
        } else if isFuture {
            return Color.gray.opacity(0.1)
        } else {
            return Color.clear
        }
    }
    
    var textColor: Color {
        if isCompleted || isToday {
            return .white
        } else if isFuture {
            return .gray
        } else {
            return .cryptoText
        }
    }
    
    var borderColor: Color {
        if isToday {
            return .cryptoGreen
        } else if !isCompleted && !isFuture {
            return .cryptoSubtext.opacity(0.3)
        } else {
            return .clear
        }
    }
}
