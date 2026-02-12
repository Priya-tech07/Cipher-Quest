
import Foundation

protocol Cipher {
    func encrypt(_ text: String, key: String) -> String
    func decrypt(_ text: String, key: String) -> String
    var type: CipherType { get }
}

class CipherFactory {
    static func getCipher(for type: CipherType) -> Cipher {
        switch type {
        case .atbash: return AtbashCipher()
        case .caesar: return CaesarCipher()
        case .vigenere: return VigenereCipher()
        }
    }
}
