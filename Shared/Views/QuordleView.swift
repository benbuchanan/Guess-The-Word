//
//  QuordleView.swift
//  Word Guess
//
//  Created by Ben Buchanan on 1/20/23.
//

import SwiftUI
import Firebase
import FirebaseAnalytics

struct QuordleView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @Binding var showHome: Bool
    @State var wordLength: Int
    @State var wordList: [String]
    @State var currentGuessCounts: [Int]
    @State var guesses: [[[LetterWithStatus]]]
    @State var keyboardLetters: [LetterWithStatus]
    @State var targetWords: [[String]]
    @State var showGameOver: Bool = false
    @State var gameOverTitleText: String = ""
    @State var scoreArray: [Int]
    @State var highlightDistributionBar: Bool = true
    @State var showDistribution: Bool = false
    @State var wordReported: Bool = false
    var alphabet: [String] = ["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P", "A", "S", "D", "F", "G", "H", "J", "K", "L", "Z", "X", "C", "V", "B", "N", "M"]
    
    init(showHome: Binding<Bool>, wordLength: Int) {
        _currentGuessCounts = State(initialValue: Array(repeating: 0, count: 4))
        _guesses = State(initialValue: Array(repeating: Array(repeating: Array(repeating: LetterWithStatus(letter: "", status: Status.normal), count: wordLength), count: 6), count: 4))
        _targetWords = State(initialValue: Array(repeating: Array(repeating: "", count: wordLength), count: 4))
        
        var initArray: [LetterWithStatus] = []
        for letter in alphabet {
            initArray.append(LetterWithStatus(letter: letter, status: Status.normal))
        }
        _keyboardLetters = State(initialValue: initArray)
        
        self._showHome = showHome
        _wordLength = State(initialValue: wordLength)
        switch wordLength {
        case 4:
            self._wordList = State(initialValue: fourLetterWordList)
        case 5:
            self._wordList = State(initialValue: fiveLetterWordList)
        case 6:
            self._wordList = State(initialValue: sixLetterWordList)
        default:
            self._wordList = State(initialValue: fiveLetterWordList)
        }
        _scoreArray = State(initialValue: UserDefaults.standard.array(forKey: String(wordLength)) as? [Int] ?? Array(repeating: 0, count: 6))
    }
        
    var body: some View {
        GeometryReader { metrics in
            ZStack {
                ZStack {
                    Rectangle().opacity(0)
                }
                .ignoresSafeArea()
                .background(colorScheme == .dark ? Color(.systemGray6) : Color(.systemBackground))

                // Title, tiles, and keyboard
                VStack(spacing: 5) {
                    // Title
                    HStack {
                        Text("WG")
                            .font(AppFont.regularFont(fontSize: 30))
                            .foregroundColor(mainColor)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                        Spacer()
                        Button(action: {
                            withAnimation(.easeInOut) {
                                self.showDistribution = true
                            }
                        }) {
                            ZStack {
                                Image(colorScheme == .dark ? "graph-white" : "graph-dark")
                                    .resizable()
                                    .frame(width: metrics.size.height / 35, height: metrics.size.height / 35)
                            }.padding(.trailing, 5)
                        }
                        .disabled(self.showGameOver)
                        
                        Button(action: {
                            withAnimation(.default) {
                                self.showHome = true
                            }
                        }) {
                            ZStack {
                                Image(colorScheme == .dark ? "home-white" : "home-dark")
                                    .resizable()
                                    .frame(width: metrics.size.height / 35, height: metrics.size.height / 35)
                            }.padding(.trailing, 20)
                        }
                    }
                    .frame(height: metrics.size.height / 25)
                    
                    // Tiles
                    Spacer()
                    GeometryReader { gtest in
                        VStack {
                            Spacer()
                            HStack {
                                VStack(spacing: 5) {
                                    ForEach(0...5, id: \.self) { i in
                                        HStack {
                                            Spacer()
                                            HStack(spacing: 5) {
                                                ForEach(0...self.wordLength - 1, id: \.self) { j in
                                                    TileView(tile: self.guesses[0][i][j], font: .title3)
                                                        .frame(width: min(gtest.size.height / 6.5 / 2.5, gtest.size.width / CGFloat(self.wordLength + 1)), height: min(gtest.size.height / 6.5 / 2.5, gtest.size.width / CGFloat(self.wordLength + 1)))
                                                }
                                            }
                                            Spacer()
                                        }
                                    }
                                }
                                VStack(spacing: 5) {
                                    ForEach(0...5, id: \.self) { i in
                                        HStack {
                                            Spacer()
                                            HStack(spacing: 5) {
                                                ForEach(0...self.wordLength - 1, id: \.self) { j in
                                                    TileView(tile: self.guesses[1][i][j], font: .title3)
                                                        .frame(width: min(gtest.size.height / 6.5 / 2.5, gtest.size.width / CGFloat(self.wordLength + 1)), height: min(gtest.size.height / 6.5 / 2.5, gtest.size.width / CGFloat(self.wordLength + 1)))
                                                }
                                            }
                                            Spacer()
                                        }
                                    }
                                }
                            }
                            Spacer()
                            HStack {
                                VStack(spacing: 5) {
                                    ForEach(0...5, id: \.self) { i in
                                        HStack {
                                            Spacer()
                                            HStack(spacing: 5) {
                                                ForEach(0...self.wordLength - 1, id: \.self) { j in
                                                    TileView(tile: self.guesses[2][i][j], font: .title3)
                                                        .frame(width: min(gtest.size.height / 6.5 / 2.5, gtest.size.width / CGFloat(self.wordLength + 1)), height: min(gtest.size.height / 6.5 / 2.5, gtest.size.width / CGFloat(self.wordLength + 1)))
                                                }
                                            }
                                            Spacer()
                                        }
                                    }
                                }
                                VStack(spacing: 5) {
                                    ForEach(0...5, id: \.self) { i in
                                        HStack {
                                            Spacer()
                                            HStack(spacing: 5) {
                                                ForEach(0...self.wordLength - 1, id: \.self) { j in
                                                    TileView(tile: self.guesses[3][i][j], font: .title3)
                                                        .frame(width: min(gtest.size.height / 6.5 / 2.5, gtest.size.width / CGFloat(self.wordLength + 1)), height: min(gtest.size.height / 6.5 / 2.5, gtest.size.width / CGFloat(self.wordLength + 1)))
                                                }
                                            }
                                            Spacer()
                                        }
                                    }
                                }
                            }
                            Spacer()
                        }
                    }
                    Spacer()
                    
                    // Keyboard
                    Spacer()
                    VStack(spacing: 10) {
                        HStack(spacing: 5) {
                            ForEach(0...9, id: \.self) { i in
                                KeyboardLetterView(kbLetter: self.keyboardLetters[i], width: metrics.size.width / 11.5, fontSize: metrics.size.width / 25).onTapGesture {
                                    for j in 0..<self.guesses.count {
                                        inputLetter(letter: self.keyboardLetters[i].letter, guessNum: j)
                                    }
                                }
                            }
                        }
                        HStack(spacing: 5) {
                            ForEach(10...18, id: \.self) { i in
                                KeyboardLetterView(kbLetter: self.keyboardLetters[i], width: metrics.size.width / 11.5, fontSize: metrics.size.width / 25).onTapGesture {
                                    for j in 0..<self.guesses.count {
                                        inputLetter(letter: self.keyboardLetters[i].letter, guessNum: j)
                                    }
                                }
                            }
                        }
                        HStack(spacing: 5) {
                            Button(action: {
                                submitGuess(guessNum: 0)
                                submitGuess(guessNum: 1)
                                submitGuess(guessNum: 2)
                                submitGuess(guessNum: 3)
                            }) {
                                ZStack {
                                    Rectangle()
                                        .foregroundColor(colorScheme == .dark ? darkGray : lightGray)
                                        .frame(width: metrics.size.width / 8, height: metrics.size.width / 11.5 * 1.3)
                                        .cornerRadius(metrics.size.width / 11.5 / 5)
                                    Text("Enter").font(.system(size: metrics.size.width / 25))
                                }
                            }
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                            ForEach(19...25, id: \.self) { i in
                                KeyboardLetterView(kbLetter: self.keyboardLetters[i], width: metrics.size.width / 11.5, fontSize: metrics.size.width / 25).onTapGesture {
                                    for j in 0..<self.guesses.count {
                                        inputLetter(letter: self.keyboardLetters[i].letter, guessNum: j)
                                    }
                                }
                            }
                            Button(action: {
                                deleteLetter(guessNum: 0)
                                deleteLetter(guessNum: 1)
                                deleteLetter(guessNum: 2)
                                deleteLetter(guessNum: 3)
                            }) {
                                ZStack {
                                    Rectangle()
                                        .foregroundColor(colorScheme == .dark ? darkGray : lightGray)
                                        .frame(width: metrics.size.width / 8, height: metrics.size.width / 11.5 * 1.3)
                                        .cornerRadius(metrics.size.width / 11.5 / 5)
                                    Image(colorScheme == .dark ? "backspace-white" : "backspace-dark")
                                        .resizable()
                                        .frame(width: metrics.size.width / 20, height: metrics.size.width / 20)
                                }
                            }
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                        }
                    }
                    Rectangle()
                        .opacity(0)
                        .frame(height:metrics.size.width / 11.5 * 1.5)
                    Spacer()
                }
                .frame(maxWidth: metrics.size.width, maxHeight: metrics.size.height)
                
//                DistributionView(scoreArray: self.$scoreArray, currentGuess: self.$currentGuess, showDistribution: self.$showDistribution)
                
//                QuordleGameOverView(showGameOver: $showGameOver, gameOverTitleText: $gameOverTitleText, targetWord: $targetWord, showHome: $showHome, scoreArray: $scoreArray, currentGuess: $currentGuess, highlightDistributionBar: $highlightDistributionBar, width: metrics.size.width - 50, height: metrics.size.height - 150, wordReported: $wordReported, newGameFunc: startNewGame)
            }
            .onAppear() {
                getNewRandomWordFromList()
            }
        }.transition(.move(edge: .trailing))
    }
    
    func submitGuess(guessNum: Int) {
        let targetWord = self.targetWords[guessNum]
        let activeGuess = self.guesses[guessNum][self.currentGuessCounts[guessNum]]
        var totalCorrectCount: Int = 0
        var correctLetterCounts: [String: Int] = [:]
        var counts: [String: Int] = [:]
        var statusArray: [LetterWithStatus] = []
        var alreadyMarkedIncorrect: [String: Bool] = [:]
        
        for item in targetWord {
            counts[item] = (counts[item] ?? 0) + 1
        }
        
        let isValidGuess = isValidGuess(guess: activeGuess)
        
        if !isValidGuess.0 {
            for i in 0..<self.guesses[guessNum][self.currentGuessCounts[guessNum]].count {
                withAnimation(.default) {
                    self.guesses[guessNum][self.currentGuessCounts[guessNum]][i].submittedIncorrectly += 1
                }
            }
            return
        }
        
        // Get correct letter count
        for i in 0..<activeGuess.count {
            if targetWord[i].lowercased() == activeGuess[i].letter.lowercased() {
                totalCorrectCount += 1
                correctLetterCounts[targetWord[i].lowercased()] = (correctLetterCounts[targetWord[i].lowercased()] ?? 0) + 1
            }
        }
        
        // Get Tile status
        for i in 0..<activeGuess.count {
            // Correct
            if targetWord[i].lowercased() == activeGuess[i].letter.lowercased() {
                withAnimation(.easeInOut(duration: 0.3).delay(0.15 * Double(i))) {
                    self.guesses[guessNum][self.currentGuessCounts[guessNum]][i].flipped.toggle()
                    self.guesses[guessNum][self.currentGuessCounts[guessNum]][i].status = Status.correct
                    statusArray.append(LetterWithStatus(letter: self.guesses[guessNum][self.currentGuessCounts[guessNum]][i].letter, status: Status.correct))
                }
            // Incorrect placement
            } else if correctLetterCounts[activeGuess[i].letter.lowercased()] ?? 0 < counts[activeGuess[i].letter.lowercased()] ?? 0 && !(alreadyMarkedIncorrect[activeGuess[i].letter.lowercased()] ?? false) {
                withAnimation(.easeInOut(duration: 0.3).delay(0.15 * Double(i))) {
                    self.guesses[guessNum][self.currentGuessCounts[guessNum]][i].flipped.toggle()
                    self.guesses[guessNum][self.currentGuessCounts[guessNum]][i].status = Status.incorrectPlacement
                    statusArray.append(LetterWithStatus(letter: self.guesses[guessNum][self.currentGuessCounts[guessNum]][i].letter, status: Status.incorrectPlacement))
                    alreadyMarkedIncorrect[activeGuess[i].letter.lowercased()] = true
                }
            // Incorrect
            } else {
                withAnimation(.easeInOut(duration: 0.3).delay(0.15 * Double(i))) {
                    self.guesses[guessNum][self.currentGuessCounts[guessNum]][i].flipped.toggle()
                    self.guesses[guessNum][self.currentGuessCounts[guessNum]][i].status = Status.incorrect
                    statusArray.append(LetterWithStatus(letter: self.guesses[guessNum][self.currentGuessCounts[guessNum]][i].letter, status: Status.incorrect))
                }
            }
        }
        
//            updateKeyboardStatus(statusArr: statusArray)
        
        if totalCorrectCount == self.wordLength {
            // Game won
            // Save score to user defaults
            // if defaults array exists, just increment index at currentGuess
            self.scoreArray[self.currentGuessCounts[guessNum]] += 1
            UserDefaults.standard.set(self.scoreArray, forKey: String(self.wordLength))
            
            self.gameOverTitleText = "Correct! You win!"
            self.highlightDistributionBar = true;
            withAnimation(.default.delay(1)) {
                self.showGameOver = true
            }
            
            FirebaseAnalytics.Analytics.logEvent("game_win", parameters: [
                "word_length": self.wordLength,
                "word": targetWord.joined(separator: ""),
                "total_wins_at_word_length": self.scoreArray.reduce(0, +)
            ])
        } else if self.currentGuessCounts[guessNum] < 5 {
            // Continue to next guess
            self.currentGuessCounts[guessNum] += 1
        } else {
            // Game lost
            self.gameOverTitleText = "Game over, you lose."
            self.highlightDistributionBar = false;
            withAnimation(.default.delay(1)) {
                self.showGameOver = true
            }
            
            FirebaseAnalytics.Analytics.logEvent("game_lose", parameters: [
                "word_length": self.wordLength,
                "word": targetWord.joined(separator: "")
            ])
        }
    }
    
    func startNewGame() {
        self.guesses = Array(repeating: Array(repeating: Array(repeating: LetterWithStatus(letter: "", status: Status.normal), count: self.wordLength), count: 6), count: 4)
        for i in 0..<self.keyboardLetters.count {
            self.keyboardLetters[i].status = Status.normal
        }
        getNewRandomWordFromList()
        self.currentGuessCounts = Array(repeating: 0, count: 4)
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
    
    func inputLetter(letter: String, guessNum: Int) {
        for i in 0..<self.guesses[guessNum][self.currentGuessCounts[guessNum]].count {
            if self.guesses[guessNum][self.currentGuessCounts[guessNum]][i].letter == "" {
                withAnimation(.linear(duration: 0.1)) {
                    self.guesses[guessNum][self.currentGuessCounts[guessNum]][i].letter = letter
                    self.guesses[guessNum][self.currentGuessCounts[guessNum]][i].scale += 0.05
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        self.guesses[guessNum][self.currentGuessCounts[guessNum]][i].scale = 1
                    }
                }
                if i+1 == self.wordLength {
                    let isValidGuess = isValidGuess(guess: self.guesses[guessNum][self.currentGuessCounts[guessNum]])
                    if !isValidGuess.0 {
                        for j in 0..<self.guesses[guessNum][self.currentGuessCounts[guessNum]].count {
                            self.guesses[guessNum][self.currentGuessCounts[guessNum]][j].invalid = true
                        }
                    }
                }
                return
            }
        }
    }
    
    func deleteLetter(guessNum: Int) {
        for i in 0..<self.guesses[guessNum][self.currentGuessCounts[guessNum]].count {
            self.guesses[guessNum][self.currentGuessCounts[guessNum]][i].invalid = false
            if self.guesses[guessNum][self.currentGuessCounts[guessNum]][i].letter == "" && i > 0 {
                self.guesses[guessNum][self.currentGuessCounts[guessNum]][i-1].letter = ""
                return
            } else if i == self.guesses[guessNum][self.currentGuessCounts[guessNum]].count - 1 {
                self.guesses[guessNum][self.currentGuessCounts[guessNum]][self.guesses[guessNum][self.currentGuessCounts[guessNum]].count - 1].letter = ""
                return
            }
        }
    }
    
    func getNewRandomWordFromList() {
        var set: Set<Int> = [Int.random(in: 0..<self.wordList.count), Int.random(in: 0..<self.wordList.count), Int.random(in: 0..<self.wordList.count), Int.random(in: 0..<self.wordList.count)]
        while set.count < 4 {
            set = [Int.random(in: 0..<self.wordList.count), Int.random(in: 0..<self.wordList.count), Int.random(in: 0..<self.wordList.count), Int.random(in: 0..<self.wordList.count)]
        }
        let uniqueNums = Array(set)
        for i in 0..<uniqueNums.count {
            self.targetWords[i] = wordList[uniqueNums[i]].map(String.init)
        }
        print(self.targetWords)
    }
    
    func isValidGuess(guess: [LetterWithStatus]) -> (Bool, String) {
        var error: String = ""

        var guessAsStringArray: [String] = []
        for tile in guess {
            if tile.letter == "" {
                return (false, "Not enough letters")
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

        error = isValidWord ? "" : "Not a valid word"

        return (isValidWord, error)
    }
}

struct QuordleView_Previews: PreviewProvider {
    static var previews: some View {
        QuordleView(showHome: .constant(false), wordLength: 5)
    }
}

