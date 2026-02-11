
import SwiftUI
import Combine

class TimerManager: ObservableObject {
    @Published var timeRemaining: TimeInterval = 0
    @Published var isRunning: Bool = false
    
    private var timer: AnyCancellable?
    private var duration: TimeInterval = 0
    
    func start(duration: TimeInterval) {
        self.duration = duration
        self.timeRemaining = duration
        self.isRunning = true
        
        timer?.cancel()
        timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.tick()
            }
    }
    
    func stop() {
        isRunning = false
        timer?.cancel()
    }
    
    func addTime(_ amount: TimeInterval) {
        timeRemaining += amount
    }
    
    private func tick() {
        guard isRunning else { return }
        
        if timeRemaining > 0 {
            timeRemaining -= 1
        } else {
            stop()
        }
    }
    
    var formattedTime: String {
        let minutes = Int(timeRemaining) / 60
        let seconds = Int(timeRemaining) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
