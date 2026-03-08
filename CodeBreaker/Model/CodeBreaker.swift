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
        "Standard Colors 1": [
            "red", "green", "blue", "yellow", "orange", "black"
        ],
        "Standard Colors 2": [
            "white", "brown", "pink", "cyan", "gray", "purple"
        ],

        "Earth Tones 1": [
            "rust", "olive", "beige", "forest", "slate", "charcoal"
        ],
        "Earth Tones 2": [
            "gold", "coffee", "sand", "clay"
        ],

        // --- VEHICLES ---
        "Vehicles 1": ["✈️", "🚀", "🚁", "🚂", "🚄", "🚗"],
        "Vehicles 2": ["🏎️", "🚓", "🚑", "🚒", "🚌", "🚜"],
        "Vehicles 3": ["🛵", "🚲", "🚢", "⛵️", "🚤", "🛸"],
        "Vehicles 4": ["🛶", "🛺"],

        // --- FACES ---
        "Faces 1": ["😀", "🤣", "😇", "😍", "🤩", "🤪"],
        "Faces 2": ["🥳", "😎", "😡", "🤢", "🤔", "🫣"],
        "Faces 3": ["🤠", "🤡", "🤑", "🤓", "🤖", "👽"],
        "Faces 4": ["👻", "💩"],

        // --- ANIMALS ---
        "Animals 1": ["🐶", "🐱", "🐭", "🐹", "🐰", "🦊"],
        "Animals 2": ["🐻", "🐼", "🐨", "🐯", "🦁", "🐮"],
        "Animals 3": ["🐷", "🐸", "🐵", "🐔", "🐧", "🐦"],
        "Animals 4": ["🐤", "🦆"],

        // --- FLAGS ---
        "Flags 1": ["🇺🇸", "🇬🇧", "🇨🇦", "🇯🇵", "🇧🇷", "🇮🇳"],
        "Flags 2": ["🇿🇦", "🇦🇺", "🇩🇪", "🇫🇷", "🇮🇹", "🇪🇸"],
        "Flags 3": ["🇨🇳", "🇰🇷", "🇲🇽", "🇷🇺", "🇹🇷", "🇸🇦"],
        "Flags 4": ["🇦🇷", "🇳🇬", "🇪🇬", "🇮🇩", "🇵🇰", "🇧🇩"],
        "Flags 5": ["🇻🇳", "🇵🇭", "🇹🇭", "🇲🇾", "🇸🇬", "🇳🇿"],

        // --- FOOD ---
        "Food 1": ["🍎", "🍌", "🍇", "🍉", "🍓", "🍒"],
        "Food 2": ["🍑", "🍍", "🥥", "🥝", "🍔", "🍕"],
        "Food 3": ["🌭", "🥪", "🌮", "🌯", "🥗", "🍿"],
        "Food 4": ["🍩", "🍪", "🎂", "🍦", "🍫", "🍬"],
        "Food 5": ["🍭", "🍮", "🍯", "🍷", "🍺", "☕️"],

        // --- NATURE ---
        "Nature 1": ["🌵", "🌲", "🌳", "🌴", "🪵", "🌱"],
        "Nature 2": ["🌿", "☘️", "🍀", "🎍", "🪴", "🎋"],
        "Nature 3": ["🍃", "🍂", "🍁", "🍄", "🐚", "🪨"],
        "Nature 4": ["🌾", "💐", "🌷", "🌹", "🥀", "🌺"],
        "Nature 5": ["🌸", "🌼", "🌻", "🌞", "🌝", "🌛"],

        // --- SPORTS ---
        "Sports 1": ["⚽️", "🏀", "🏈", "⚾️", "🥎", "🎾"],
        "Sports 2": ["🏐", "🏉", "🎱", "🏓", "🏸", "🏒"],
        "Sports 3": ["🏑", "🥍", "🏏", "🥊", "🥋", "🥅"],
        "Sports 4": ["⛳️", "⛸️", "🎣", "🤿", "🎽", "🎿"],
        "Sports 5": ["🛷", "🥌", "🎯", "🎳", "🎮", "🎰"]
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
        
        masterCode = Code(pegCount: pegCount, kind: .master(isHidden: true))
        guess = Code(pegCount: pegCount, kind: .guess)
        masterCode.randomize(from: self.pegChoices)
        print(masterCode)
    }
    
    var isOver: Bool {
        attempts.last?.pegs == masterCode.pegs
    }
    
    // append guess to atempts[] if not attempted previously
    mutating func attemptGuess(){
        // guards to check if guess have no pegs or previously guessed
        if attempts.contains(where: {$0.pegs == guess.pegs}) { return }
        if guess.pegs.contains(Code.missingPeg) {return}
        
        var attempt = guess
        attempt.kind = .attempt(guess.match(against: masterCode))
        attempts.append(attempt)
        guess.reset()
        
        if isOver {
            masterCode.kind = .master(isHidden: false)
        }
    }
    
    mutating func setGuessPeg(_ peg: Peg, at index: Int) {
        guard guess.pegs.indices.contains(index) else { return }
        guess.pegs[index] = peg
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
        
        masterCode = Code(pegCount: pegCount, kind: .master(isHidden: true))
        masterCode.randomize(from: pegChoices)
        guess = Code(pegCount: pegCount, kind: .guess)
        attempts.removeAll()
    }
    
}



