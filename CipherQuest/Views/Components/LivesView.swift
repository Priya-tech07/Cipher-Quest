
import SwiftUI

struct LivesView: View {
    var lives: Int = 3
    
    var body: some View {
        HStack {
            ForEach(0..<3) { i in
                Image(systemName: "heart.fill")
                    .foregroundColor(i < lives ? .red : .gray)
            }
        }
    }
}
