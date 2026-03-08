//
//  CodeView.swift
//  CodeBreaker
//
//  Created by PRINCE  on 2/17/26.
//

import SwiftUI

struct CodeView<AncillaryView>: View  where AncillaryView: View{
    //MARK: Data In
    let code: Code
    
    //MARK: Data Shared with me
    @Binding var selection: Int
    // var _selection: Binding<Int> is there we just don't see it
    
    @ViewBuilder let ancillaryView: () -> AncillaryView
    
    init(
        code: Code,
        selection: Binding<Int> = .constant(-1),
    @ViewBuilder ancillaryView: @escaping () -> AncillaryView = { EmptyView() }
    ) {
        self.code = code
        self._selection = selection
        self.ancillaryView = ancillaryView
    }
    //MARK: -- Body
    
    
    var body: some View {
        HStack{
            ForEach(code.pegs.indices, id: \.self) {index in
                PegView(peg: code.pegs[index])
                    .padding(Selection.border)
                    .background {
                        if selection == index , code.kind == .guess {
                            Selection.shape
                                .foregroundColor(Selection.color)
                        }
                    }
                    .overlay {
                        Selection.shape.foregroundStyle(code.isHidden ? Color.gray : .clear)
                    }
                    .onTapGesture {
                        if code.kind == .guess {
                            selection = index
                        }
                    }
            }
            Rectangle().foregroundStyle(Color.clear).aspectRatio(1, contentMode: .fit)
                .overlay {
                    ancillaryView ()
//                    if let matches = code.matches {
//                        MatchMarkers( matches: matches, pegCount: game.pegCount)
//                    }else {
//                        if code.kind == .guess {
//                            guessButton
//                        }
//                    }
                }
        }
        
    }
}

fileprivate struct Selection{
    static let border: CGFloat = 5
    static let cornerRadius: CGFloat = 10
    static let color: Color = Color.gray(0.85)
    static let shape = RoundedRectangle(cornerRadius: cornerRadius)
}

//#Preview {
//    CodeView()
//}
