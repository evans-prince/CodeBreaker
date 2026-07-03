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
    @State private var spinDegrees = 0.0
    
    //MARK: - Body
    
    
    var body: some View {
        VStack{
            HStack{
                themeTitle
                Spacer()
                restartButton
                    .rotationEffect(.degrees(spinDegrees))
            }
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
            if !game.isOver && !restarting {
                PegChooser(choices: game.pegChoices, onChoose: changePegAtSelection )
                    .transition(.pegChooser) // origin -> top left & down ->y +ve
            }
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
            .animation(nil, value: game.currentThemeName)
            .opacity(restarting ? 0 : 1)
            .scaleEffect(restarting ? 0.1 : 1)
    }
    var restartButton: some View {
        Button("Restart", systemImage: "arrow.circlepath", action: restart)
            .font(.system(size: 30))
            .minimumScaleFactor(0.1)
            .labelStyle(.iconOnly)
    }
    
    func restart() {
        withAnimation(.restart){
            spinDegrees -= 180
            restarting = true
        } completion: {
            withAnimation(.restart){
                spinDegrees -= 180
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
