//
//  ContentView.swift
//  Shared
//
//  Created by Ben Buchanan on 1/30/22.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    enum Status: String {
        case normal = "normal"
        case correct = "correct"
        case incorrectPlacement = "incorrect_placement"
        case incorrect = "incorrect"
    }
    
    var testWord: [String] = ["r", "a", "r", "e", "s"]
    // Increment on 'Enter'
    @State var currentGuess: Int = 0
    @State var guesses: [[Tile]] = Array(repeating: Array(repeating: Tile(letter: "", status: Status.normal), count: 5), count: 6)
    
    var alphabet: [String] = ["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P", "A", "S", "D", "F", "G", "H", "J", "K", "L", "Z", "X", "C", "V", "B", "N", "M"]
    
    var body: some View {
        ZStack {
            // Title and word squares
            VStack(spacing: 5) {
                Text("Guess the Word")
                    .font(.title)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                ForEach(0...5, id: \.self) { i in
                    HStack(spacing: 5) {
                        ForEach(0...4, id: \.self) { j in
                            let guessTile = self.guesses[i][j]
                            ZStack {
                                Rectangle()
                                    .fill(guessTile.color)
                                    .border(guessTile.status == Status.normal ? .gray : guessTile.color, width: 1.5)
                                    .frame(width: 65, height: 65)
                                Text(guessTile.letter)
                                    .font(.title).fontWeight(.bold)
                            }
                        }
                    }
                }
                Spacer()
            }
            
            // Keyboard
            VStack {
                Spacer()
                VStack {
                    HStack(spacing: 5) {
                        ForEach(alphabet[0...9], id: \.self) { letter in
                            KeyboardLetter(letter: letter).onTapGesture {
                                inputLetter(letter: letter)
                            }
                        }
                    }
                    HStack(spacing: 5) {
                        ForEach(alphabet[10...18], id: \.self) { letter in
                            KeyboardLetter(letter: letter).onTapGesture {
                                inputLetter(letter: letter)
                            }
                        }
                    }
                    HStack(spacing: 5) {
                        Button(action: submitGuess) {
                            ZStack {
                                Rectangle()
                                    .foregroundColor(colorScheme == .dark ? .gray : .black.opacity(0.2))
                                    .frame(width: 55, height: 50)
                                    .cornerRadius(5)
                                Text("Enter")
                            }
                        }
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                        ForEach(alphabet[19...25], id: \.self) { letter in
                            KeyboardLetter(letter: letter).onTapGesture {
                                inputLetter(letter: letter)
                            }
                        }
                        Button(action: deleteLetter) {
                            ZStack {
                                Rectangle()
                                    .foregroundColor(colorScheme == .dark ? .gray : .black.opacity(0.2))
                                    .frame(width: 55, height: 50)
                                    .cornerRadius(5)
                                Text("Del")
                            }
                        }
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                    }
                }
            }
        }
    }
    
    func submitGuess() {
        let activeGuess = self.guesses[self.currentGuess]
        var totalCorrectCount: Int = 0
        var correctLetterCounts: [String: Int] = [:]
        var counts: [String: Int] = [:]

        for item in self.testWord {
            counts[item] = (counts[item] ?? 0) + 1
        }
        
        if !isValidGuess(arr: activeGuess) {
            // TODO: render a popup warning that dissapears
            print("Error: guess does not have 5 letters")
            return
        }
        
        // Get correct letter count
        for i in 0..<activeGuess.count {
            if testWord[i].lowercased() == activeGuess[i].letter.lowercased() {
                totalCorrectCount += 1
                correctLetterCounts[self.testWord[i].lowercased()] = (correctLetterCounts[self.testWord[i].lowercased()] ?? 0) + 1
            }
        }
        
        // Get Tile status
        for i in 0..<activeGuess.count {
            if testWord[i].lowercased() == activeGuess[i].letter.lowercased() {
                self.guesses[self.currentGuess][i].status = Status.correct
            } else if correctLetterCounts[activeGuess[i].letter.lowercased()] ?? 0 < counts[activeGuess[i].letter.lowercased()] ?? 0 {
                self.guesses[self.currentGuess][i].status = Status.incorrectPlacement
            } else {
                self.guesses[self.currentGuess][i].status = Status.incorrect
            }
        }
        
        if totalCorrectCount == 5 {
            // TODO: render you won game over screen
            print("Correct! Game Over")
        } else {
            self.currentGuess += 1
        }
    }
    
    func inputLetter(letter: String) {
        for i in 0..<self.guesses[self.currentGuess].count {
            if self.guesses[self.currentGuess][i].letter == "" {
                self.guesses[self.currentGuess][i].letter = letter
                return
            }
        }
    }
    
    func deleteLetter() {
        for i in 0..<self.guesses[self.currentGuess].count {
            if self.guesses[self.currentGuess][i].letter == "" && i > 0 {
                self.guesses[self.currentGuess][i-1].letter = ""
            }
        }
    }
    
    func isValidGuess(arr: [Tile]) -> Bool {
        var hasEmptyString = false
        for tile in arr {
            if tile.letter == "" {
                hasEmptyString = true
            }
        }
        return !hasEmptyString
    }
    
    struct Tile {
        var letter: String
        var status: Status
        var color: Color {
            switch status {
            case Status.normal:
                return Color.black.opacity(0)
            case Status.correct:
                return Color.green
            case Status.incorrectPlacement:
                return Color.yellow
            case Status.incorrect:
                return Color.gray
            }
        }
    }
}

struct KeyboardLetter: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    var letter: String
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(colorScheme == .dark ? .gray : .black.opacity(0.2)) // Change this with guesses
                .frame(width: 30, height: 50)
                .cornerRadius(5)
            Text(letter)
                .foregroundColor(colorScheme == .dark ? .white : .black)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
