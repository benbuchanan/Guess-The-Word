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
    var width: Double
    var kbColor: Color {
        switch kbLetter.status {
        case Status.normal:
            return colorScheme == .dark ? darkGray : lightGray
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
                .foregroundColor(kbColor)
                .frame(width: self.width, height: self.width * 1.5)
                .cornerRadius(self.width / 5)
            Text(kbLetter.letter)
                .foregroundColor(colorScheme == .dark ? .white : .black)
        }
    }
}

struct Previews_KeyboardLetterView_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
