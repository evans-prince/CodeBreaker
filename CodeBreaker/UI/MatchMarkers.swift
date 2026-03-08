//
//  MatchMarkers.swift
//  CodeBreaker
//
//  Created by PRINCE  on 2/11/26.
//

import SwiftUI

enum Match{
    case nomatch
    case exact
    case inexact
}


struct MatchMarkers: View {
    //MARK: Data In
    let matches: [Match]
    var pegCount: Int = 4
    
    //        let exactCount: Int = matches.count(where : {match in match == .exact})
    var exactCount: Int { matches.count{$0 == .exact}}
    var foundCount: Int { matches.count{$0 != .nomatch}}
    
    //MARK - Body
    
    
    var body: some View {
        HStack {
            ForEach(Array(stride(from: 0, to: pegCount, by: 2)), id: \.self) { index in
                VStack{
                    matchMarker(peg: index)
                    if(index+1 < 6) {
                        matchMarker(peg: index+1)
                    }
                }
            }
        }
    }
    
        // we can skip return if no let or we can add @viewbuilder
    func matchMarker(peg: Int)-> some View{
        return Circle()
            .fill(exactCount > peg ? Color.primary : Color.clear)
            .strokeBorder(foundCount > peg ? Color.primary : Color.clear, lineWidth: 2 )
            .aspectRatio(1, contentMode: .fit)
            
    }
}


/// Puts dummy pegs  with matchmarkers to look good 
struct MatchMarkersPreview: View {
    let matchesArr : [Match]
    var body : some View {
        HStack {
            ForEach (0..<matchesArr.count, id: \.self) {_ in
                Circle()
                    .foregroundStyle(.primary)
                    .aspectRatio(1, contentMode: .fit)
            }
            MatchMarkers(matches: matchesArr)
            Spacer()
        }
        .frame(height:45)
        .padding()
    }
}


#Preview {
    VStack {
        MatchMarkersPreview(matchesArr: [.exact, .inexact , .inexact])
        MatchMarkersPreview(matchesArr: [ .exact , .nomatch, .nomatch])
        MatchMarkersPreview(matchesArr: [.exact , .inexact , .inexact, .exact])
        MatchMarkersPreview(matchesArr: [.exact , .nomatch, .inexact, .inexact])
        MatchMarkersPreview(matchesArr: [.exact , .nomatch, .nomatch, .inexact])
        MatchMarkersPreview(matchesArr: [.exact , .exact, .exact, .inexact, .nomatch, .nomatch])
        MatchMarkersPreview(matchesArr: [.exact , .exact, .exact, .inexact, .inexact, .inexact])
        MatchMarkersPreview(matchesArr: [.inexact , .exact, .exact, .inexact, .inexact])
        MatchMarkersPreview(matchesArr: [.exact, .nomatch, .inexact, .nomatch, .inexact])
//        MatchMarkers(matches:[.exact , .inexact , .inexact])
    }
    .padding()
}
