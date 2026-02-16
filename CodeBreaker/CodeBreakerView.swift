//
//  CodeBreakerView.swift
//  CodeBreaker
//
//  Created by PRINCE  on 2/11/26.
//

import SwiftUI

struct CodeBreakerView: View {
    @State var game = CodeBreaker(pegChoices: ["brown", "yellow", "orange", "black"], pegCount: 5)
    
    var body: some View {
        VStack{
            Text(game.currentThemeName)
                .fontWeight(.bold)
                .font(.system(size: 40))
                .minimumScaleFactor(20/40)
                .foregroundStyle(.primary)
            view(for: game.masterCode)
            ScrollView{
                view(for: game.guess)
                ForEach(game.attempts.indices.reversed(), id: \.self) { index in
                    view (for: game.attempts[index])
                }
            }
            
            restartButton
        }
        .padding()
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
            }
        }
        .font(.system(size: 80))
        .minimumScaleFactor(0.1)
    }
    
    func view(for code : Code) -> some View {
        HStack{
            ForEach(code.pegs.indices, id: \.self) {index in
                draw( peg: code.pegs[index])
                    .overlay {
                        if code.pegs[index] == Code.missing {
                            RoundedRectangle(cornerRadius: 10)
                                .strokeBorder(Color.gray)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if code.kind == .guess {
                            game.changeGuessPeg(at: index)
                        }
                    }
            }
            MatchMarkers( matches: code.matches, pegCount: game.pegCount)
                .overlay {
                    if code.kind == .guess {
                        guessButton
                    }
                }
        }
    }
    
    @ViewBuilder
    func draw(peg: String) -> some View {
        if let color = Color(fromName: peg){
//            RoundedRectangle(cornerRadius: 10)
            Circle()
                .foregroundStyle(color)
                .aspectRatio(1, contentMode: .fit)
            
        }else{
            Circle()
                .foregroundStyle(Color.clear)
                .overlay{
                    Text(peg)
                        .font(.system(size: 120))
                        .minimumScaleFactor(9/120)
                }
        }
    }
}



#Preview {
    CodeBreakerView()
}
