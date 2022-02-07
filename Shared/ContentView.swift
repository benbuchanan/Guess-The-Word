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
    @State var targetWord: [String] = ["", "", "", "", ""]
    @State var showGameOver: Bool = false
    @State var gameOverTitleText: String = ""
    @State var showWarningView: Bool = false
    @State var warningText: String = ""
    var alphabet: [String] = ["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P", "A", "S", "D", "F", "G", "H", "J", "K", "L", "Z", "X", "C", "V", "B", "N", "M"]
    
    init() {
        var initArray: [LetterWithStatus] = []
        for letter in alphabet {
            initArray.append(LetterWithStatus(letter: letter, status: Status.normal))
        }
        _keyboardLetters = State(initialValue: initArray)
    }
        
    var body: some View {
        GeometryReader { metrics in
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
                                    .frame(width: metrics.size.width / 6, height: metrics.size.width / 6)
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
                                }.frame(width: metrics.size.width / 11.5)
                            }
                        }
                        HStack(spacing: 5) {
                            ForEach(10...18, id: \.self) { i in
                                KeyboardLetterView(kbLetter: self.keyboardLetters[i]).onTapGesture {
                                    inputLetter(letter: self.keyboardLetters[i].letter)
                                }.frame(width: metrics.size.width / 11.5)
                            }
                        }
                        HStack(spacing: 5) {
                            Button(action: submitGuess) {
                                ZStack {
                                    Rectangle()
                                        .foregroundColor(colorScheme == .dark ? darkGray : lightGray)
                                        .frame(width: 50, height: 50)
                                        .cornerRadius(5)
                                    Text("Enter")
                                }
                            }
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                            ForEach(19...25, id: \.self) { i in
                                KeyboardLetterView(kbLetter: self.keyboardLetters[i]).onTapGesture {
                                    inputLetter(letter: self.keyboardLetters[i].letter)
                                }.frame(width: metrics.size.width / 11.5)
                            }
                            Button(action: deleteLetter) {
                                ZStack {
                                    Rectangle()
                                        .foregroundColor(colorScheme == .dark ? darkGray : lightGray)
                                        .frame(width: 50, height: 50)
                                        .cornerRadius(5)
                                    Image(colorScheme == .dark ? "backspace-white" : "backspace-dark")
                                        .resizable()
                                        .frame(width: 25, height: 25)
                                }
                            }
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                        }
                    }.padding(.bottom, 50)
                }
                ShortWarningView(showWarningView: $showWarningView, warningText: $warningText)
                GameOverView(showGameOver: $showGameOver, gameOverTitleText: $gameOverTitleText, targetWord: $targetWord, newGameFunc: startNewGame)
            }
            .onAppear() {
                getNewRandomWordFromList()
            }
        }
    }
    
    // TODO: add animation to tiles on guess submission
    func submitGuess() {
        let activeGuess = self.guesses[self.currentGuess]
        var totalCorrectCount: Int = 0
        var correctLetterCounts: [String: Int] = [:]
        var counts: [String: Int] = [:]
        var statusArray: [LetterWithStatus] = []
        var alreadyMarkedIncorrect: [String: Bool] = [:]

        for item in self.targetWord {
            counts[item] = (counts[item] ?? 0) + 1
        }
        
        let isValidGuess = isValidGuess(guess: activeGuess)
        
        if !isValidGuess.0 {
            self.warningText = isValidGuess.1
            self.showWarningView = true
            return
        }
        
        // Get correct letter count
        for i in 0..<activeGuess.count {
            if targetWord[i].lowercased() == activeGuess[i].letter.lowercased() {
                totalCorrectCount += 1
                correctLetterCounts[self.targetWord[i].lowercased()] = (correctLetterCounts[self.targetWord[i].lowercased()] ?? 0) + 1
            }
        }
        
        // Get Tile status
        for i in 0..<activeGuess.count {
            // Correct
            if targetWord[i].lowercased() == activeGuess[i].letter.lowercased() {
                withAnimation(.easeInOut(duration: 0.3).delay(0.15 * Double(i))) {
                    self.guesses[self.currentGuess][i].flipped.toggle()
                    self.guesses[self.currentGuess][i].status = Status.correct
                    statusArray.append(LetterWithStatus(letter: self.guesses[self.currentGuess][i].letter, status: Status.correct))
                }
            // Incorrect placement
            } else if correctLetterCounts[activeGuess[i].letter.lowercased()] ?? 0 < counts[activeGuess[i].letter.lowercased()] ?? 0 && !(alreadyMarkedIncorrect[activeGuess[i].letter.lowercased()] ?? false) {
                withAnimation(.easeInOut(duration: 0.3).delay(0.15 * Double(i))) {
                    self.guesses[self.currentGuess][i].flipped.toggle()
                    self.guesses[self.currentGuess][i].status = Status.incorrectPlacement
                    statusArray.append(LetterWithStatus(letter: self.guesses[self.currentGuess][i].letter, status: Status.incorrectPlacement))
                    alreadyMarkedIncorrect[activeGuess[i].letter.lowercased()] = true
                }
            // Incorrect
            } else {
                withAnimation(.easeInOut(duration: 0.3).delay(0.15 * Double(i))) {
                    self.guesses[self.currentGuess][i].flipped.toggle()
                    self.guesses[self.currentGuess][i].status = Status.incorrect
                    statusArray.append(LetterWithStatus(letter: self.guesses[self.currentGuess][i].letter, status: Status.incorrect))
                }
            }
        }
        
        updateKeyboardStatus(statusArr: statusArray)
        
        if totalCorrectCount == 5 {
            self.gameOverTitleText = "Correct! You win!"
            withAnimation(.default.delay(1)) {
                self.showGameOver = true
            }
        } else if self.currentGuess < 5 {
            self.currentGuess += 1
        } else {
            // TODO: game over screen here
            self.gameOverTitleText = "You lose. Game over."
            withAnimation(.default.delay(1)) {
                self.showGameOver = true
            }
        }
    }
    
    func startNewGame() {
        self.guesses = Array(repeating: Array(repeating: LetterWithStatus(letter: "", status: Status.normal), count: 5), count: 6)
        for i in 0..<self.keyboardLetters.count {
            self.keyboardLetters[i].status = Status.normal
        }
        getNewRandomWordFromList()
        self.currentGuess = 0
        self.showGameOver = false
    }
    
    func updateKeyboardStatus(statusArr: [LetterWithStatus]) {
        for letter in statusArr {
            for i in 0..<self.keyboardLetters.count {
                if self.keyboardLetters[i].letter == letter.letter {
                    if self.keyboardLetters[i].status == Status.correct {
                        continue
                    } else if self.keyboardLetters[i].status == Status.incorrectPlacement {
                        if letter.status != Status.incorrect {
                            self.keyboardLetters[i].status = letter.status
                        }
                    } else {
                        self.keyboardLetters[i].status = letter.status
                    }
                }
            }
        }
    }
    
    func inputLetter(letter: String) {
        for i in 0..<self.guesses[self.currentGuess].count {
            if self.guesses[self.currentGuess][i].letter == "" {
                withAnimation(.linear(duration: 0.1)) {
                    self.guesses[self.currentGuess][i].letter = letter
                    self.guesses[self.currentGuess][i].scale += 0.05
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        self.guesses[self.currentGuess][i].scale = 1
                    }
                }
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
    
    func getNewRandomWordFromList() {
        self.targetWord = wordList[Int.random(in: 0..<5757)].map(String.init)
    }
    
    func isValidGuess(guess: [LetterWithStatus]) -> (Bool, String) {
        var error: String = ""

        var guessAsStringArray: [String] = []
        for tile in guess {
            if tile.letter == "" {
                return (false, "Guess does not have 5 letters")
            }
            guessAsStringArray.append(tile.letter)
        }

        let guessString: String = guessAsStringArray.joined(separator: "").lowercased()
        var isValidWord = false
        for word in wordList {
            if word == guessString {
                isValidWord = true
                break
            }
        }

        error = isValidWord ? "" : "Guess is not a valid word"

        return (isValidWord, error)
    }
}

struct GameOverView: View {
    @Environment(\.colorScheme) var colorScheme

    @Binding var showGameOver: Bool
    @Binding var gameOverTitleText: String
    @Binding var targetWord: [String]
    var newGameFunc: () -> Void
    
    // TODO: display overall stats here and maybe leaderboard in the future?
    
    var body: some View {
        if showGameOver {
            ZStack {
                Color.black
                    .opacity(0.6)
                    .ignoresSafeArea()
                ZStack {
                    VStack {
                        Text(self.gameOverTitleText).foregroundColor(colorScheme == .dark ? .white : .black)
                        Text("The word was \(self.targetWord.joined(separator: ""))").foregroundColor(colorScheme == .dark ? .white : .black)
                        Button(action: {
                            self.newGameFunc()
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 15).fill(.white)
                                Text("New word").foregroundColor(.black)
                            }.frame(width: 100, height: 30)
                        }
                    }
                }
                .frame(width: 300, height:450)
                .background(colorScheme == .dark ? darkGray : lightGray)
                .cornerRadius(30)
            }.transition(.opacity)
        }
    }
}

struct ShortWarningView: View {
    @Environment(\.colorScheme) var colorScheme

    @Binding var showWarningView: Bool
    @Binding var warningText: String
    
    // TODO: fix zindex of this modal
        
    var body: some View {
        if showWarningView {
            VStack {
                Text(self.warningText).foregroundColor(colorScheme == .dark ? .white : .black)
            }
            .frame(width: 200, height:50)
            .background(colorScheme == .dark ? darkGray : lightGray)
            .cornerRadius(30)
            .transition(.opacity)
            .onAppear() {
                withAnimation(.default.delay(3)) {
                    self.showWarningView = false
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
