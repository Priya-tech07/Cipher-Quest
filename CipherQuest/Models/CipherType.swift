
import Foundation

enum CipherType: String, CaseIterable, Codable {
    case caesar = "Caesar Cipher"
    case vigenere = "Vigenère Cipher"
    case playfair = "Playfair Cipher"
    
    var description: String {
        switch self {
        case .caesar: return "Shift letters by a fixed number."
        case .vigenere: return "Use a keyword to shift letters."
        case .playfair: return "Digraph substitution using a grid."
        }
    }
    
    var difficulty: Int {
        switch self {
        case .caesar: return 1
        case .vigenere: return 2
        case .playfair: return 3
        }
    }
    
    var rules: String {
        switch self {
        case .caesar:
            return """
            🟢 **1) Caesar Cipher (Beginner)**
            
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
            
            👉 Easy, fast, beginner level.
            """
        case .vigenere:
            return """
            🟡 **2) Vigenère Cipher (Intermediate)**
            
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
            
            👉 Smarter than Caesar because shift keeps changing.
            """
        case .playfair:
            return """
            🔴 **3) Playfair Cipher (Advanced)**
            
            This one is FUN and puzzle-like 🧩
            Instead of single letters, we encrypt pairs of letters.
            
            **Step 1** — Create 5×5 Grid Using Keyword
            Keyword example: MONARCHY
            Fill grid (I & J share one box):
            M O N A R
            C H Y B D
            E F G I K
            L P Q S T
            U V W X Z
            
            **Step 2** — Prepare Message
            Rules:
            - Remove spaces
            - Replace J → I
            - Split into pairs
            - Add X if needed
            Example: HIDE GOLD → HI DE GO LD
            
            **Step 3** — Apply 3 Rules
            Rule 1 — Same Row → Move RIGHT
            Example: MO → ON
            
            Rule 2 — Same Column → Move DOWN
            Example: MU → CM
            
            Rule 3 — Rectangle Rule 🔲 (Most common rule)
            Take letters at the other corners of rectangle.
            Example: HI → BF
            
            🔓 **Decryption**
            Reverse directions:
            - Same row → move LEFT
            - Same column → move UP
            - Rectangle rule same
            
            👉 This cipher feels like solving a puzzle.
            """
        }
    }
}
