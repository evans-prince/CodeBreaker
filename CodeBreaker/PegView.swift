//
//  PegView.swift
//  CodeBreaker
//
//  Created by PRINCE  on 2/17/26.
//

import SwiftUI

struct PegView: View {
    // MARK: Data In
    let peg: Peg
    
    // MARK: - Body
    
    let pegShape = Circle()
    
    var body: some View {
        draw(peg)
            .overlay {
                if peg == Code.missingPeg {
                    pegShape
                        .strokeBorder(Color.gray)
                }
            }
            .contentShape(pegShape)
    }
    
    @ViewBuilder
    func draw(_ peg: String) -> some View {
        if let color = Color(fromName: peg){
            pegShape
                .foregroundStyle(color)
                .aspectRatio(1, contentMode: .fit)
            
        }else{
            pegShape
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
    PegView(peg: "blue")
        .padding()
}
