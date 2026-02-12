
import Foundation

enum CipherType: String, CaseIterable, Codable {
    case atbash = "Atbash Cipher"
    case caesar = "Caesar Cipher"
    case vigenere = "Vigenère Cipher"
    
    var description: String {
        switch self {
        case .atbash: return "Reverse the alphabet (A↔Z, B↔Y)."
        case .caesar: return "Shift letters by a fixed number."
        case .vigenere: return "Use a keyword to shift letters."
        }
    }
    
    var difficulty: Int {
        switch self {
        case .atbash: return 1
        case .caesar: return 2
        case .vigenere: return 3
        }
    }
    
    var rules: String {
        switch self {
        case .atbash:
            return """
            🟢 **1) Atbash Cipher (Beginner)**
            
            🧠 **Idea**
            The Atbash cipher maps the alphabet to its reverse.
            First letter becomes the last, second becomes second-to-last, etc.
            
            **Mapping**
            A ↔ Z
            B ↔ Y
            C ↔ X
            ...
            M ↔ N
            
            🔐 **Encryption & Decryption**
            It is symmetric! Applying it twice gives back the original message.
            
            **Example**:
            Message: HELLO
            H ↔ S
            E ↔ V
            L ↔ O
            L ↔ O
            O ↔ L
            Result: SVOOL
            
            👉 Easiest cipher. No key needed.
            """
        case .caesar:
            return """
            🟡 **2) Caesar Cipher (Intermediate)**
            
            🧠 **Idea**
            Shift every letter in the message by a fixed number in the alphabet.
            It’s like rotating the alphabet.
            
            **Example** (shift = 3)
            Plain alphabet : ABCDEFGHIJKLMNOPQRSTUVWXYZ
            Shifted by 3   : DEFGHIJKLMNOPQRSTUVWXYZABC
            
            🔐 **Encryption Formula**
            Encrypted = (Letter + Shift) mod 26
            
            **Example**:
            Message: HELLO
            Shift = 3
            H → K
            E → H
            L → O
            L → O
            O → R
            Encrypted: KHOOR
            
            🔓 **Decryption**
            Shift backwards.
            Plain = (Encrypted − Shift + 26) mod 26
            
            👉 Classic and reliable.
            """
        case .vigenere:
            return """
            🔴 **3) Vigenère Cipher (Advanced)**
            
            🧠 **Idea**
            Instead of one fixed shift, we use a keyword that changes the shift for every letter.
            This makes it much harder to break.
            
            **Step 1** — Choose a keyword
            Example keyword: KEY
            
            **Step 2** — Repeat keyword under message
            Message: HELLOWORLD
            Keyword repeated: KEYKEYKEYK
            
            **Step 3** — Convert letters to numbers
            A=0 … Z=25
            
            🔐 **Encryption Formula**
            Encrypted = (Plain + Key) mod 26
            Each letter uses a different shift based on keyword.
            
            **Example Result**
            HELLO + KEY → RIJVS
            
            🔓 **Decryption**
            Plain = (Encrypted − Key + 26) mod 26
            
            👉 The "Unbreakable" Cipher (historically).
            """
        }
    }
}
