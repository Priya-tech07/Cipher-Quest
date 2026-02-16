
import SwiftUI

struct CalendarView: View {
    @ObservedObject var viewModel: GameViewModel
    
    let days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    let columns = Array(repeating: GridItem(.flexible()), count: 7)
    
    @State private var currentMonth: Date = Date()
    
    var body: some View {
        ZStack {
            Color.cryptoDarkBlue.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                // Header
                ZStack {
                    // Centered Month/Year Navigation (Dropdowns)
                    HStack(spacing: 8) {
                        // Month Dropdown
                        Menu {
                            ForEach(1...12, id: \.self) { index in
                                Button(Calendar.current.monthSymbols[index - 1]) {
                                    setMonth(index)
                                }
                            }
                        } label: {
                            Text(currentMonthName())
                                .font(.system(size: 20, weight: .bold, design: .monospaced))
                                .foregroundColor(.cryptoText)
                        }

                        // Year Dropdown
                        Menu {
                            ForEach(2024...2030, id: \.self) { year in
                                Button(String(year)) {
                                    setYear(year)
                                }
                            }
                        } label: {
                            Text(currentYearString())
                                .font(.system(size: 20, weight: .bold, design: .monospaced))
                                .foregroundColor(.cryptoText)
                        }
                    }
                    
                    // Left-aligned Back Button
                    HStack {
                        Button(action: { viewModel.closeCalendar() }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 20, weight: .bold)) // Slightly larger icon since no text
                                .foregroundColor(Color(hex: "007AFF"))
                                .padding(10)
                        }
                        Spacer()
                    }
                }
                .padding(.horizontal)
                .padding(.top, 20)
                
                // Days of Week
                HStack {
                    ForEach(days, id: \.self) { day in
                        Text(day)
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.cryptoSubtext)
                            .frame(maxWidth: .infinity)
                    }
                }
                .padding(.horizontal)
                
                // Calendar Grid
                LazyVGrid(columns: columns, spacing: 15) {
                    ForEach(daysInMonth(), id: \.self) { date in
                        if let date = date {
                            DayCell(date: date, viewModel: viewModel)
                        } else {
                            Text("")
                        }
                    }
                }
                .padding(.horizontal)
                .transition(.opacity) // Should add animation ideally
                
                Spacer()
                
                // Legend or Stats
                HStack(spacing: 30) {
                    VStack {
                        Text("\(DailyChallengeManager.shared.currentStreak)")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.cryptoGreen)
                        Text("Day Streak")
                            .font(.caption)
                            .foregroundColor(.cryptoSubtext)
                    }
                    
                    VStack {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.title)
                            .foregroundColor(.cryptoBlue)
                        Text("Completed")
                            .font(.caption)
                            .foregroundColor(.cryptoSubtext)
                    }
                }
                .padding()
                .background(Color.cryptoNavy)
                .cornerRadius(15)
                .padding(.bottom, 30)
            }
        }
    }
    
    func changeMonth(by value: Int) {
        if let newMonth = Calendar.current.date(byAdding: .month, value: value, to: currentMonth) {
            withAnimation {
                currentMonth = newMonth
            }
        }
    }
    
    func setMonth(_ monthIndex: Int) {
        // monthIndex is 1-based (1...12)
        var components = Calendar.current.dateComponents([.year, .month, .day], from: currentMonth)
        components.month = monthIndex
        if let newDate = Calendar.current.date(from: components) {
            withAnimation {
                currentMonth = newDate
            }
        }
    }
    
    func setYear(_ year: Int) {
        var components = Calendar.current.dateComponents([.year, .month, .day], from: currentMonth)
        components.year = year
        if let newDate = Calendar.current.date(from: components) {
            withAnimation {
                currentMonth = newDate
            }
        }
    }
    
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
    
    func daysInMonth() -> [Date?] {
        let calendar = Calendar.current
        let range = calendar.range(of: .day, in: .month, for: currentMonth)!
        let numDays = range.count
        
        let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: currentMonth))!
        let firstWeekday = calendar.component(.weekday, from: firstDayOfMonth)
        
        var days: [Date?] = Array(repeating: nil, count: firstWeekday - 1)
        
        for day in 1...numDays {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: firstDayOfMonth) {
                days.append(date)
            }
        }
        
        return days
    }
}

struct DayCell: View {
    var date: Date
    @ObservedObject var viewModel: GameViewModel
    
    private let calendar = Calendar.current
    
    var isToday: Bool {
        calendar.isDateInToday(date)
    }
    
    var isFuture: Bool {
        // Simple future check: date start > today start
        let todayStart = calendar.startOfDay(for: Date())
        let dateStart = calendar.startOfDay(for: date)
        return dateStart > todayStart
    }
    
    var isCompleted: Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        let seed = Int(formatter.string(from: date)) ?? 0
        
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
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(textColor)
            }
            .frame(width: 40, height: 40)
            .background(backgroundColor)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(borderColor, lineWidth: 2)
            )
        }
        .disabled(isFuture || isCompleted) // Disable if future or already done
        .opacity(isFuture ? 0.3 : 1.0) // Dim if future
    }
    
    var backgroundColor: Color {
        if isToday {
            return .cryptoGreen // Always Bright Blue for Today
        } else if isCompleted {
            if calendar.isDateInYesterday(date) {
                return .cryptoBlue.opacity(0.5) // Light Blue for yesterday
            } else {
                return .cryptoBlue // Default Blue for other completed days
            }
        } else if isFuture {
            return .gray.opacity(0.1)
        } else {
            return .clear // Past, uncompleted
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
            return .cryptoSubtext.opacity(0.3) // Light border for past playable days
        } else {
            return .clear
        }
    }
}
