//
//  CodeBreaker.swift
//  CodeBreaker
//
//  Created by PRINCE  on 2/15/26.
//

import Foundation

typealias Peg = String

struct CodeBreaker {
    var masterCode:  Code
    var guess: Code
    var attempts: [Code] = []
    var pegChoices: [Peg]
    var pegCount: Int
    var currentThemeName: String = "Custom"
    
    static let themes: [String: [Peg]] = [
            // --- COLOR THEMES ---
            "Standard Colors": [
                "red", "green", "blue", "yellow", "orange", "black",
                "white", "brown", "pink", "cyan", "gray", "purple"
            ],
            
            "Earth Tones": [
                "rust", "olive", "beige", "forest", "slate", "charcoal",
                "gold", "coffee", "sand", "clay"
            ],

            // --- EMOJI THEMES ---
            "Vehicles": [
                "✈️", "🚀", "🚁", "🚂", "🚄", "🚗", "🏎️", "🚓", "🚑", "🚒",
                "🚌", "🚜", "🛵", "🚲", "🚢", "⛵️", "🚤", "🛸", "🛶", "🛺"
            ],
            
            "Faces": [
                "😀", "🤣", "😇", "😍", "🤩", "🤪", "🥳", "😎", "😡", "🤢",
                "🤔", "🫣", "🤠", "🤡", "🤑", "🤓", "🤖", "👽", "👻", "💩"
            ],
            
            "Animals": [
                "🐶", "🐱", "🐭", "🐹", "🐰", "🦊", "🐻", "🐼", "🐨", "🐯",
                "🦁", "🐮", "🐷", "🐸", "🐵", "🐔", "🐧", "🐦", "🐤", "🦆"
            ],

            "Flags": [
                "🇺🇸", "🇬🇧", "🇨🇦", "🇯🇵", "🇧🇷", "🇮🇳", "🇿🇦", "🇦🇺", "🇩🇪", "🇫🇷",
                "🇮🇹", "🇪🇸", "🇨🇳", "🇰🇷", "🇲🇽", "🇷🇺", "🇹🇷", "🇸🇦", "🇦🇷", "🇳🇬",
                "🇪🇬", "🇮🇩", "🇵🇰", "🇧🇩", "🇻🇳", "🇵🇭", "🇹🇭", "🇲🇾", "🇸🇬", "🇳🇿"
            ],

            "Food": [
                "🍎", "🍌", "🍇", "🍉", "🍓", "🍒", "🍑", "🍍", "🥥", "🥝",
                "🍔", "🍕", "🌭", "🥪", "🌮", "🌯", "🥗", "🍿", "🍩", "🍪",
                "🎂", "🍦", "🍫", "🍬", "🍭", "🍮", "🍯", "🍷", "🍺", "☕️"
            ],

            "Nature": [
                "🌵", "🌲", "🌳", "🌴", "🪵", "🌱", "🌿", "☘️", "🍀", "🎍",
                "🪴", "🎋", "🍃", "🍂", "🍁", "🍄", "🐚", "🪨", "🌾", "💐",
                "🌷", "🌹", "🥀", "🌺", "🌸", "🌼", "🌻", "🌞", "🌝", "🌛"
            ],

            "Sports": [
                "⚽️", "🏀", "🏈", "⚾️", "🥎", "🎾", "🏐", "🏉", "🎱", "🏓",
                "🏸", "🏒", "🏑", "🥍", "🏏", "🥊", "🥋", "🥅", "⛳️", "⛸️",
                "🎣", "🤿", "🎽", "🎿", "🛷", "🥌", "🎯", "🎳", "🎮", "🎰"
            ]
        ]
    
    init (pegChoices: [Peg]? = nil, pegCount: Int = 4) {
        self.pegCount = pegCount
        
        if let choices = pegChoices {
            self.pegChoices = choices
            self.currentThemeName = "Custom"
        }else {
            let randomThemeName = CodeBreaker.themes.keys.randomElement()!
            self.currentThemeName = randomThemeName
            self.pegChoices = CodeBreaker.themes[randomThemeName]!
        }
        
        masterCode = Code(pegCount: pegCount, kind: .master)
        guess = Code(pegCount: pegCount, kind: .guess)
        masterCode.randomize(from: self.pegChoices)
        print(masterCode)
    }
    
    // append guess to atempts[] if not attempted previously
    mutating func attemptGuess(){
        // guards to check if guess have no pegs or previously guessed
        if attempts.contains(where: {$0.pegs == guess.pegs}) { return }
        if guess.pegs.contains(Code.missingPeg) {return}
        
        var attempt = guess
        attempt.kind = .attempt(guess.match(against: masterCode))
        attempts.append(attempt)
    }
    
    mutating func changeGuessPeg(at index: Int) {
        let existingPeg = guess.pegs[index]
        if let indexOfExistingPegInPegChoices = pegChoices.firstIndex(of: existingPeg) {
            let newPeg = pegChoices[(indexOfExistingPegInPegChoices + 1) % pegChoices.count]
            guess.pegs[index] = newPeg
        }else{
            guess.pegs[index] = pegChoices.first ?? Code.missingPeg
        }
    }
    
    mutating func restartGame(){
        pegCount = Int.random(in: 3...6)
        
        let randomThemeName = CodeBreaker.themes.keys.randomElement()!
        self.currentThemeName = randomThemeName
        self.pegChoices = CodeBreaker.themes[randomThemeName]!
        
        masterCode = Code(pegCount: pegCount, kind: .master)
        masterCode.randomize(from: pegChoices)
        guess = Code(pegCount: pegCount, kind: .guess)
        attempts.removeAll()
    }
    
}

struct Code {
    var kind: Kind
    var pegs: [Peg] = []
    
    static let missingPeg: Peg = "clear"
    
    init (pegCount: Int, kind: Kind) {
        self.pegs = Array(repeating: Code.missingPeg, count: pegCount)
        self.kind = kind
    }
    enum Kind: Equatable {
        case master
        case guess
        case attempt([Match])
        case unkown
    }
    
    mutating func randomize(from pegChoices: [Peg]) {
        for index in pegs.indices {
            pegs[index] = pegChoices.randomElement() ?? Code.missingPeg
        }
    }
    
    var matches: [Match]? {
        switch kind{
        case.attempt(let matches): return matches
        default: return nil
        }
    }
    
    func match(against otherCode: Code) -> [Match] {
        var pegsToMatch = otherCode.pegs
        let backwardsExactMatches = pegs.indices.reversed().map { index in
            if pegsToMatch.count > index , pegsToMatch[index] == pegs[index] {
                pegsToMatch.remove(at: index)
                return Match.exact
            }else {
                return .nomatch
            }
        }
        let exactMatches = Array(backwardsExactMatches.reversed())
        return pegs.indices.map { index in
            if exactMatches[index] != .exact, let matchIndex = pegsToMatch.firstIndex(of: pegs[index]) {
                pegsToMatch.remove(at: matchIndex)
                return .inexact
            }else {
                return exactMatches[index]
            }
        }
    }
}

