import SwiftUI

struct NameInputView: View {
    @ObservedObject var viewModel: GameViewModel
    @State private var agentName: String = ""
    
    var body: some View {
        ZStack {
            // Background Layer
            Color.black.opacity(0.85).edgesIgnoringSafeArea(.all)
            
            // Blur Effect
            Rectangle().fill(.ultraThinMaterial)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                // Icon
                Image(systemName: "person.crop.square.fill.and.at.rectangle")
                    .font(.system(size: 60))
                    .foregroundColor(.blue)
                
                // Prompt
                VStack(spacing: 10) {
                    Text("IDENTIFY YOURSELF")
                        .font(.system(size: 24, weight: .black, design: .monospaced))
                        .foregroundColor(.black)
                    
                    Text("Enter your codename for the agency records.")
                        .font(.system(size: 14, design: .monospaced))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                
                // Input Field
                TextField("AGENT NAME", text: $agentName)
                    .font(.system(size: 20, weight: .bold, design: .monospaced))
                    .foregroundColor(.black)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12) // Inner field doesn't need 20 if card is 20
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.blue, lineWidth: 2)
                    )
                    .padding(.horizontal, 20)
                    .submitLabel(.done)
                
                // Submit Button
                Button(action: submitName) {
                    Text("CONFIRM IDENTITY")
                        .font(.system(size: 16, weight: .bold, design: .monospaced))
                        .foregroundColor(.white)
                        .padding(.vertical, 15)
                        .padding(.horizontal, 30)
                        .background(agentName.isEmpty ? Color.gray : Color.blue)
                        .cornerRadius(12)
                }
                .disabled(agentName.isEmpty)
            }
            .padding(.vertical, 40)
            .padding(.horizontal, 20)
            .background(Color.white)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.blue, lineWidth: 4)
            )
            .padding(.horizontal, 40) // Spacing from screen edges
        }
        .transition(.opacity)
    }
    
    private func submitName() {
        guard !agentName.isEmpty else { return }
        viewModel.updateAgentName(agentName)
        viewModel.nextOnboardingStep()
    }
}
