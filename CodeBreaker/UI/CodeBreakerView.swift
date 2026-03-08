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
    @State private var restarting = false
    @State private var hideMostRecentMarkers = false
    
    //MARK: - Body
    
    
    var body: some View {
        VStack{
            themeTitle
            CodeView(code: game.masterCode)
            ScrollView{
                if !game.isOver || restarting {
                    CodeView(code: game.guess, selection: $selection) {
                        Button("Guess", action: guess).flexibleSystemFont()
                    }
                    .animation(nil, value: game.attempts.count)
                    .opacity(restarting ? 0 : 1)
                }
                ForEach(game.attempts.indices.reversed(), id: \.self) { index in
                    CodeView(code: game.attempts[index]) {
                        let showMarkers = !hideMostRecentMarkers  || index != game.attempts.count - 1
                        if showMarkers, let matches = game.attempts[index].matches {
                            MatchMarkers(matches: matches)
                        }
                    }
                    .transition(AnyTransition.attempt(game.isOver))
                }
            }
            if !game.isOver{
                PegChooser(choices: game.pegChoices, onChoose: changePegAtSelection )
                    .transition(.pegChooser) // origin -> top left & down ->y +ve
            }
            restartButton
        }
        .padding()
    }
    
    func changePegAtSelection( to peg: Peg){
        game.setGuessPeg(peg, at: selection)
        selection = (selection + 1) % game.pegCount
    }
    var themeTitle: some View{
        Text(game.currentThemeName)
            .fontWeight(.bold)
            .font(.system(size: 40))
            .minimumScaleFactor(20/40)
            .foregroundStyle(.primary)
    }
    var restartButton: some View {
        Button("Restart", systemImage: "arrow.circlepath", action: restart)
            .font(.system(size: 30))
            .minimumScaleFactor(0.1)
    }
    
    func restart() {
        withAnimation(.restart){
            restarting = true
        } completion: {
            withAnimation(.restart){
                game.restartGame()
                selection = 0
                restarting = false
            }
        }
    }
    
    func guess() {
        withAnimation(.guess){
            game.attemptGuess()
            selection = 0
            hideMostRecentMarkers = true
        } completion: {
            withAnimation(.guess) {
                hideMostRecentMarkers = false
            }
        }
    }
    
}

#Preview {
    CodeBreakerView()
}
