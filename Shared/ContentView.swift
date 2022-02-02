//
//  ContentView.swift
//  Shared
//
//  Created by Ben Buchanan on 1/30/22.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    // Increment on 'Enter'
    @State var currentGuess: Int = 0
    @State var guesses: [[LetterWithStatus]] = Array(repeating: Array(repeating: LetterWithStatus(letter: "", status: Status.normal), count: 5), count: 6)
    @State var keyboardLetters: [LetterWithStatus]
    var alphabet: [String] = ["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P", "A", "S", "D", "F", "G", "H", "J", "K", "L", "Z", "X", "C", "V", "B", "N", "M"]
    var testWord: [String] = ["r", "a", "r", "e", "s"]
    
    init() {
        var initArray: [LetterWithStatus] = []
        for letter in alphabet {
            initArray.append(LetterWithStatus(letter: letter, status: Status.normal))
        }
        _keyboardLetters = State(initialValue: initArray)
    }
        
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
                            TileView(tile: self.guesses[i][j])
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
                        ForEach(0...9, id: \.self) { i in
                            KeyboardLetterView(kbLetter: self.keyboardLetters[i]).onTapGesture {
                                inputLetter(letter: self.keyboardLetters[i].letter)
                            }
                        }
                    }
                    HStack(spacing: 5) {
                        ForEach(10...18, id: \.self) { i in
                            KeyboardLetterView(kbLetter: self.keyboardLetters[i]).onTapGesture {
                                inputLetter(letter: self.keyboardLetters[i].letter)
                            }
                        }
                    }
                    HStack(spacing: 5) {
                        Button(action: submitGuess) {
                            ZStack {
                                Rectangle()
                                    .foregroundColor(colorScheme == .dark ? darkGray : lightGray)
                                    .frame(width: 55, height: 50)
                                    .cornerRadius(5)
                                Text("Enter")
                            }
                        }
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                        ForEach(19...25, id: \.self) { i in
                            KeyboardLetterView(kbLetter: self.keyboardLetters[i]).onTapGesture {
                                inputLetter(letter: self.keyboardLetters[i].letter)
                            }
                        }
                        Button(action: deleteLetter) {
                            ZStack {
                                Rectangle()
                                    .foregroundColor(colorScheme == .dark ? darkGray : lightGray)
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
        var statusDict: [String: Status] = [:]

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
            // Correct
            if testWord[i].lowercased() == activeGuess[i].letter.lowercased() {
                self.guesses[self.currentGuess][i].status = Status.correct
                statusDict[self.guesses[self.currentGuess][i].letter] = Status.correct
            // Incorrect placement
            } else if correctLetterCounts[activeGuess[i].letter.lowercased()] ?? 0 < counts[activeGuess[i].letter.lowercased()] ?? 0 {
                self.guesses[self.currentGuess][i].status = Status.incorrectPlacement
                statusDict[self.guesses[self.currentGuess][i].letter] = Status.incorrectPlacement
            // Incorrect
            } else {
                self.guesses[self.currentGuess][i].status = Status.incorrect
                statusDict[self.guesses[self.currentGuess][i].letter] = Status.incorrect
            }
        }
        
        updateKeyboardStatus(statusDict: statusDict)
        
        if totalCorrectCount == 5 {
            // TODO: render you won game over screen
            print("Correct! Game Over")
        } else {
            self.currentGuess += 1
        }
    }
    
    func updateKeyboardStatus(statusDict: [String: Status]) {
        for (key, value) in statusDict {
            for i in 0..<self.keyboardLetters.count {
                if self.keyboardLetters[i].letter == key && self.keyboardLetters[i].status != Status.correct {
                    self.keyboardLetters[i].status = value
                }
            }
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
                return
            } else if i == self.guesses[self.currentGuess].count - 1 {
                self.guesses[self.currentGuess][self.guesses[self.currentGuess].count - 1].letter = ""
                return
            }
        }
    }
    
    func isValidGuess(arr: [LetterWithStatus]) -> Bool {
        var hasEmptyString = false
        for tile in arr {
            if tile.letter == "" {
                hasEmptyString = true
            }
        }
        return !hasEmptyString
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
