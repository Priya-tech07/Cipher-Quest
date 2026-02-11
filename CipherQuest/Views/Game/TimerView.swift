
import SwiftUI

struct TimerView: View {
    @ObservedObject var manager: TimerManager
    
    var body: some View {
        HStack {
            Image(systemName: "clock")
                .foregroundColor(.cryptoSubtext)
            Text(manager.formattedTime)
                .font(.system(.body, design: .monospaced))
                .bold()
                .foregroundColor(manager.timeRemaining < 10 ? .cryptoError : .cryptoText)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(Color.white)
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}
