//
//  TileView.swift
//  Word Guess
//
//  Created by Ben Buchanan on 2/2/22.
//

import SwiftUI

struct TileView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var tile: LetterWithStatus
    var tileColor: Color {
        switch tile.status {
        case Status.normal:
            return Color.black.opacity(0)
        case Status.correct:
            return Color.green
        case Status.incorrectPlacement:
            return Color(UIColor.systemCyan)
        case Status.incorrect:
            return colorScheme == .dark ? darkDark : lightIncorrect
        }
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(tileColor)
                .border(tile.status != Status.normal ? tileColor : tile.letter != "" ? colorScheme == .dark ? darkBorder : lightBorder : colorScheme == .dark ? darkDark : lightGray, width: 2)
                .rotation3DEffect(Angle(degrees: tile.flipped ? 180 : 0), axis: (x: 0, y: 1, z: 0))
            Text(tile.letter)
                .foregroundColor(tile.status != Status.normal ? .white : colorScheme == .dark ? .white : .black)
                .font(.title)
                .fontWeight(.bold)
                .animation(.none)
        }
        .scaleEffect(tile.scale)
    }
}
