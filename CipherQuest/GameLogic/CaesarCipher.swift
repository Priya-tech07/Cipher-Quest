
import Foundation

class CaesarCipher: Cipher {
    var type: CipherType = .caesar
    
    func encrypt(_ text: String, key: String) -> String {
        let shift = Int(key) ?? 3
        return process(text, shift: shift)
    }
    
    func decrypt(_ text: String, key: String) -> String {
        let shift = Int(key) ?? 3
        return process(text, shift: -shift)
    }
    
    private func process(_ text: String, shift: Int) -> String {
        let scalarA = UnicodeScalar("A").value
        let scalarZ = UnicodeScalar("Z").value
        let count = Int(scalarZ - scalarA + 1)
        
        return String(text.uppercased().unicodeScalars.map { scalar in
            guard scalar.value >= scalarA && scalar.value <= scalarZ else { return Character(scalar) }
            // Perform shift
            var shifted = Int(scalar.value) + shift
            while shifted < Int(scalarA) { shifted += count }
            while shifted > Int(scalarZ) { shifted -= count }
            return Character(UnicodeScalar(shifted)!)
        })
    }
}
