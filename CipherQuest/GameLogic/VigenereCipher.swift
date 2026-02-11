
import Foundation

class VigenereCipher: Cipher {
    var type: CipherType = .vigenere
    
    func encrypt(_ text: String, key: String) -> String {
        return process(text, key: key, encrypt: true)
    }
    
    func decrypt(_ text: String, key: String) -> String {
        return process(text, key: key, encrypt: false)
    }
    
    private func process(_ text: String, key: String, encrypt: Bool) -> String {
        let keyScalars = Array(key.uppercased().unicodeScalars.filter { $0.isASCII && $0.properties.isAlphabetic })
        guard !keyScalars.isEmpty else { return text }
        
        var result = ""
        var keyIndex = 0
        let scalarA = UnicodeScalar("A").value
        let count = 26
        
        for scalar in text.uppercased().unicodeScalars {
            guard scalar.isASCII && scalar.properties.isAlphabetic else {
                result.append(Character(scalar))
                continue
            }
            
            let charValue = Int(scalar.value - scalarA)
            let keyValue = Int(keyScalars[keyIndex % keyScalars.count].value - scalarA)
            
            let shifted: Int
            if encrypt {
                shifted = (charValue + keyValue) % count
            } else {
                shifted = (charValue - keyValue + count) % count
            }
            
            result.append(Character(UnicodeScalar(shifted + Int(scalarA))!))
            keyIndex += 1
        }
        return result
    }
}
