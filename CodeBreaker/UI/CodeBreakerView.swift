//
//  CodeBreakerView.swift
//  CodeBreaker
//
//  Created by PRINCE  on 2/11/26.
//

import SwiftUI

struct CodeBreakerView: View {
    //MARK: Data Owned by me
    @State private var game = CodeBreaker(pegChoices: ["brown", "yellow", "orange", "black"], pegCount: 5)
    
    @State private var selection: Int = 0
    
    //MARK: - Body
    
    
    var body: some View {
        VStack{
            themeTitle
            CodeView(code: game.masterCode)
            ScrollView{
                if !game.isOver {
                    CodeView(code: game.guess, selection: $selection) {
                        guessButton
                    }
                }
                ForEach(game.attempts.indices.reversed(), id: \.self) { index in
                    CodeView(code: game.attempts[index]) {
                        if let matches = game.attempts[index].matches {
                            MatchMarkers(matches: matches)
                        }
                    }
                }
            }
            PegChooser(choices: game.pegChoices) { peg in
                game.setGuessPeg(peg, at: selection)
                selection = (selection + 1) % game.pegCount
            }
            restartButton
        }
        .padding()
    }
    
    var themeTitle: some View{
        Text(game.currentThemeName)
            .fontWeight(.bold)
            .font(.system(size: 40))
            .minimumScaleFactor(20/40)
            .foregroundStyle(.primary)
    }
    var restartButton: some View {
        Button("Restart") {
            withAnimation{
                game.restartGame()
            }
        }
        .font(.system(size: 30))
        .minimumScaleFactor(0.1)
    }
    
    var guessButton: some View {
        Button("Guess") {
            withAnimation{
                game.attemptGuess()
                selection = 0
            }
        }
        .font(.system(size: GuessButton.maximumFontSize))
        .minimumScaleFactor(GuessButton.scaleFactor)
    }

    struct GuessButton {
        static let mimimumFontSize: CGFloat = 8
        static let maximumFontSize: CGFloat = 80
        static let scaleFactor = mimimumFontSize / maximumFontSize

    }
    
}



#Preview {
    CodeBreakerView()
}
