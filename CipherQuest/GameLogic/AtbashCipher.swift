
import Foundation

class AtbashCipher: Cipher {
    var type: CipherType {
        return .atbash
    }
    
    func encrypt(_ text: String, key: String = "") -> String {
        return process(text)
    }
    
    func decrypt(_ text: String, key: String = "") -> String {
        return process(text)
    }
    
    private func process(_ text: String) -> String {
        let uppercase = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ")
        let reversed = Array(uppercase.reversed())
        
        var result = ""
        
        for char in text.uppercased() {
            if let index = uppercase.firstIndex(of: char) {
                result.append(reversed[index])
            } else {
                result.append(char)
            }
        }
        
        return result
    }
}
