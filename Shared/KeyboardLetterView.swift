//
//  KeyboardLetterView.swift
//  Word Guess
//
//  Created by Ben Buchanan on 2/2/22.
//

import SwiftUI

struct KeyboardLetterView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var kbLetter: LetterWithStatus
    var kbColor: Color {
        switch kbLetter.status {
        case Status.normal:
            return colorScheme == .dark ? darkGray : lightGray
        case Status.correct:
            return Color.green
        case Status.incorrectPlacement:
            return Color.yellow
        case Status.incorrect:
            return colorScheme == .dark ? darkDark : lightIncorrect
        }
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(kbColor)
                .frame(width: 33, height: 50)
                .cornerRadius(5)
            Text(kbLetter.letter)
                .foregroundColor(colorScheme == .dark ? .white : .black)
        }
    }
}
