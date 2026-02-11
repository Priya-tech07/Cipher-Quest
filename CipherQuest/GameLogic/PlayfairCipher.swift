
import Foundation

class PlayfairCipher: Cipher {
    var type: CipherType = .playfair
    
    func encrypt(_ text: String, key: String) -> String {
        // Limited implementation for simplicity, full playfair requires matrix logic
        // For this demo, we'll swap pairs or use a simpler mock if complexity is too high, 
        // but let's try a standard matrix construction.
        let matrix = createMatrix(key: key)
        let pairs = createPairs(text: text)
        return pairs.map { encodePair($0, matrix: matrix) }.joined()
    }
    
    func decrypt(_ text: String, key: String) -> String {
        let matrix = createMatrix(key: key)
        let pairs = createPairs(text: text) // Actually text is already pairs
        return pairs.map { decodePair($0, matrix: matrix) }.joined()
    }
    
    private func createMatrix(key: String) -> [[Character]] {
        var used = Set<Character>()
        var alphabet = [Character]()
        
        // J is usually omitted or merged with I
        let keyClean = key.uppercased().filter { $0.isLetter && $0 != "J" }
        
        for char in keyClean {
            if !used.contains(char) {
                used.insert(char)
                alphabet.append(char)
            }
        }
        
        for code in UInt8(ascii: "A")...UInt8(ascii: "Z") {
            let char = Character(UnicodeScalar(code))
            if char == "J" { continue }
            if !used.contains(char) {
                used.insert(char)
                alphabet.append(char)
            }
        }
        
        var matrix = [[Character]]()
        for i in 0..<5 {
            let row = Array(alphabet[i*5..<(i+1)*5])
            matrix.append(row)
        }
        return matrix
    }
    
    private func createPairs(text: String) -> [(Character, Character)] {
        let clean = text.uppercased().filter { $0.isLetter && $0 != "J" }.map { $0 }
        var result = [(Character, Character)]()
        var i = 0
        while i < clean.count {
            let a = clean[i]
            var b = (i + 1 < clean.count) ? clean[i+1] : "X"
            
            if a == b {
                b = "X"
                i += 1 // Don't consume the second char from input, stick X between
            } else {
                i += 2
            }
            result.append((a, b))
        }
        return result
    }
    
    private func position(of char: Character, matrix: [[Character]]) -> (Int, Int) {
        for r in 0..<5 {
            for c in 0..<5 {
                if matrix[r][c] == char {
                    return (r, c)
                }
            }
        }
        return (0, 0)
    }
    
    private func encodePair(_ pair: (Character, Character), matrix: [[Character]]) -> String {
        let (r1, c1) = position(of: pair.0, matrix: matrix)
        let (r2, c2) = position(of: pair.1, matrix: matrix)
        
        if r1 == r2 {
            return String([matrix[r1][(c1+1)%5], matrix[r2][(c2+1)%5]])
        } else if c1 == c2 {
            return String([matrix[(r1+1)%5][c1], matrix[(r2+1)%5][c2]])
        } else {
            return String([matrix[r1][c2], matrix[r2][c1]])
        }
    }
    
    private func decodePair(_ pair: (Character, Character), matrix: [[Character]]) -> String {
        let (r1, c1) = position(of: pair.0, matrix: matrix)
        let (r2, c2) = position(of: pair.1, matrix: matrix)
        
        if r1 == r2 {
            return String([matrix[r1][(c1+4)%5], matrix[r2][(c2+4)%5]])
        } else if c1 == c2 {
            return String([matrix[(r1+4)%5][c1], matrix[(r2+4)%5][c2]])
        } else {
            return String([matrix[r1][c2], matrix[r2][c1]])
        }
    }
}
