//
//  ContentView.swift
//  Shared
//
//  Created by Ben Buchanan on 1/30/22.
//

import SwiftUI

struct ContentView: View {
    
    enum Status: String {
        case normal = "normal"
        case correct = "correct"
        case incorrectPlacement = "incorrect_placement"
        case incorrect = "incorrect"
    }
    
    var testWord: [String] = ["r", "a", "n", "t", "s"]
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
                            ZStack {
                                Text(self.guesses[i][j].letter)
                                Rectangle()
                                    .foregroundColor(.black.opacity(0))
                                    .border(Color.black, width: 2)
                                    .frame(width: 65, height: 65)
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
                                Text("Enter")
                                Rectangle()
                                    .foregroundColor(.black.opacity(0.2))
                                    .frame(width: 55, height: 50)
                                    .cornerRadius(5)
                            }
                        }
                        ForEach(alphabet[19...25], id: \.self) { letter in
                            KeyboardLetter(letter: letter).onTapGesture {
                                inputLetter(letter: letter)
                            }
                        }
                        ZStack {
                            Text("Del")
                            Rectangle()
                                .foregroundColor(.black.opacity(0.2))
                                .frame(width: 55, height: 50)
                                .cornerRadius(5)
                        }
                    }
                }
            }
        }
    }
    
    func submitGuess() {
        // TODO: use objects inside the 2d "guesses" array
        // that stores the character and its status.
        // ie correct placement, in word but wrong placement, or incorrect
        let activeGuess = self.guesses[self.currentGuess]
        var correctPlaceCount = 0
        if !isValidGuess(arr: activeGuess) {
            print("Error: guess does not have 5 letters")
            return
            // TODO: render a popup warning that dissapears
        }
        for i in 0..<activeGuess.count {
            if testWord[i].lowercased() == activeGuess[i].letter.lowercased() {
                correctPlaceCount += 1
                self.guesses[self.currentGuess][i].status = Status.correct
            }
        }
        
        currentGuess += 1
        print("You have \(correctPlaceCount) letters in the right spot.")
    }
    
    func inputLetter(letter: String) {
        for i in 0..<self.guesses[self.currentGuess].count {
            if self.guesses[self.currentGuess][i].letter == "" {
                self.guesses[self.currentGuess][i].letter = letter
                return
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
    }
}

struct KeyboardLetter: View {
    var letter: String
    
    var body: some View {
        ZStack {
            Text(letter)
            Rectangle()
                .foregroundColor(.black.opacity(0.2)) // Change this with guesses
                .frame(width: 30, height: 50)
                .cornerRadius(5)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
