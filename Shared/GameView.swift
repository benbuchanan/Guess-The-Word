//
//  GameView.swift
//  Word Guess
//
//  Created by Ben Buchanan on 2/8/22.
//

import SwiftUI
import Firebase

struct GameView: View {
    
    // TODO: hints
    // Have hints that people can buy
    // Winning games gives hints but also purchaseable
    // TODO: Google analytics events
    // TODO: IMPORTANT - Help screen with tile color meanings and how to report words
    
    @Environment(\.colorScheme) var colorScheme
    
    @Binding var showHome: Bool
    @State var wordLength: Int
    @State var wordList: [String]
    @State var currentGuess: Int = 0
    @State var guesses: [[LetterWithStatus]]
    @State var keyboardLetters: [LetterWithStatus]
    @State var targetWord: [String] = ["", "", "", "", ""]
    @State var showGameOver: Bool = false
    @State var gameOverTitleText: String = ""
    @State var showWarningView: Bool = false
    @State var warningText: String = ""
    @State var scoreArray: [Int]
    @State var highlightDistributionBar: Bool = true
    var alphabet: [String] = ["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P", "A", "S", "D", "F", "G", "H", "J", "K", "L", "Z", "X", "C", "V", "B", "N", "M"]
    
    init(showHome: Binding<Bool>, wordLength: Int) {
        _guesses = State(initialValue: Array(repeating: Array(repeating: LetterWithStatus(letter: "", status: Status.normal), count: wordLength), count: 6))
        
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
                // Title, tiles, and keyboard
                VStack(spacing: 5) {
                    // Title
                    HStack {
                        Text("Word Guessr")
                            .font(AppFont.regularFont(fontSize: 30))
                            .foregroundColor(colorScheme == .dark ? mainColor : secondaryColor)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                        Spacer()
                        Button(action: {
                            withAnimation(.default) {
                                self.showHome = true
                            }
                        }) {
                            ZStack {
                                Circle()
                                    .fill(colorScheme == .dark ? darkGray : lightGray)
                                    .frame(width: 40, height: 40)
                                Image(colorScheme == .dark ? "home-white" : "home-dark")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                            }.padding(.trailing, 20)
                        }
                    }
                    
                    // Tiles
                    ForEach(0...5, id: \.self) { i in
                        HStack(spacing: 5) {
                            ForEach(0...self.wordLength - 1, id: \.self) { j in
                                TileView(tile: self.guesses[i][j])
                                    .frame(width: self.wordLength == 6 ? metrics.size.width / 7 : metrics.size.width / 6, height: self.wordLength == 6 ? metrics.size.width / 7 : metrics.size.width / 6)
                            }
                        }
                    }
                    
                    // Keyboard
                    Spacer()
                    VStack {
                        HStack(spacing: 5) {
                            ForEach(0...9, id: \.self) { i in
                                KeyboardLetterView(kbLetter: self.keyboardLetters[i], width: metrics.size.width / 11.5).onTapGesture {
                                    inputLetter(letter: self.keyboardLetters[i].letter)
                                }
                            }
                        }
                        HStack(spacing: 5) {
                            ForEach(10...18, id: \.self) { i in
                                KeyboardLetterView(kbLetter: self.keyboardLetters[i], width: metrics.size.width / 11.5).onTapGesture {
                                    inputLetter(letter: self.keyboardLetters[i].letter)
                                }
                            }
                        }
                        HStack(spacing: 5) {
                            Button(action: submitGuess) {
                                ZStack {
                                    Rectangle()
                                        .foregroundColor(colorScheme == .dark ? darkGray : lightGray)
                                        .frame(width: metrics.size.width / 8, height: metrics.size.width / 11.5 * 1.5)
                                        .cornerRadius(5)
                                    Text("Enter")
                                }
                            }
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                            ForEach(19...25, id: \.self) { i in
                                KeyboardLetterView(kbLetter: self.keyboardLetters[i], width: metrics.size.width / 11.5).onTapGesture {
                                    inputLetter(letter: self.keyboardLetters[i].letter)
                                }
                            }
                            Button(action: deleteLetter) {
                                ZStack {
                                    Rectangle()
                                        .foregroundColor(colorScheme == .dark ? darkGray : lightGray)
                                        .frame(width: metrics.size.width / 8, height: metrics.size.width / 11.5 * 1.5)
                                        .cornerRadius(5)
                                    Image(colorScheme == .dark ? "backspace-white" : "backspace-dark")
                                        .resizable()
                                        .frame(width: 25, height: 25)
                                }
                            }
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                        }
                    }
                    Spacer()
                }.frame(maxHeight: metrics.size.height)
                
                ShortWarningView(showWarningView: $showWarningView, warningText: $warningText).offset(y: -metrics.size.height / 5)
                
                // Dim background for the game over screen
                if self.showGameOver {
                    Color.black
                        .opacity(0.6)
                        .ignoresSafeArea()
                }
                
                GameOverView(showGameOver: $showGameOver, gameOverTitleText: $gameOverTitleText, targetWord: $targetWord, showHome: $showHome, scoreArray: $scoreArray, currentGuess: $currentGuess, highlightDistributionBar: $highlightDistributionBar, width: metrics.size.width - 50, height: metrics.size.height - 150, newGameFunc: startNewGame)
            }
            .onAppear() {
                getNewRandomWordFromList()
            }
        }.transition(.move(edge: .trailing))
    }
    
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
        
        if totalCorrectCount == self.wordLength {
            // Game won
            // Save score to user defaults
            // if defaults array exists, just increment index at currentGuess
            self.scoreArray[self.currentGuess] += 1
            UserDefaults.standard.set(self.scoreArray, forKey: String(self.wordLength))
            
            self.gameOverTitleText = "Correct! You win!"
            self.highlightDistributionBar = true;
            withAnimation(.default.delay(1)) {
                self.showGameOver = true
            }
            
            FirebaseAnalytics.Analytics.logEvent("game_win", parameters: [
                "word_length": self.wordLength,
                "word": self.targetWord.joined(separator: ""),
                "total_wins_at_word_length": self.scoreArray.reduce(0, +)
            ])
        } else if self.currentGuess < 5 {
            // Continue to next guess
            self.currentGuess += 1
        } else {
            // Game lost
            self.gameOverTitleText = "Game over, you lose."
            self.highlightDistributionBar = false;
            withAnimation(.default.delay(1)) {
                self.showGameOver = true
            }
            
            FirebaseAnalytics.Analytics.logEvent("game_lose", parameters: [
                "word_length": self.wordLength,
                "word": self.targetWord.joined(separator: "")
            ])
        }
    }
    
    func startNewGame() {
        self.guesses = Array(repeating: Array(repeating: LetterWithStatus(letter: "", status: Status.normal), count: self.wordLength), count: 6)
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
        self.targetWord = wordList[Int.random(in: 0..<self.wordList.count)].map(String.init)
        print(self.targetWord)
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

struct GameOverView: View {
    @Environment(\.colorScheme) var colorScheme

    @Binding var showGameOver: Bool
    @Binding var gameOverTitleText: String
    @Binding var targetWord: [String]
    @Binding var showHome: Bool
    @Binding var scoreArray: [Int]
    @Binding var currentGuess: Int
    @Binding var highlightDistributionBar: Bool
    @State var width: CGFloat
    @State var height: CGFloat
    var newGameFunc: () -> Void
    
    // TODO: display overall stats here and maybe leaderboard in the future?
    // A graph of stats like wordle?
    
    var body: some View {
        if showGameOver {
            ZStack {
                GeometryReader { metrics in
                    VStack {
                        Spacer()
                        
                        Text(self.gameOverTitleText)
                            .font(AppFont.mediumFont(fontSize: 25))
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                            .padding(.bottom)
                        
                        (Text("The word was ")
                            .font(AppFont.regularFont(fontSize: 20))
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                        + Text(self.targetWord.joined(separator: ""))
                            .font(AppFont.boldFont(fontSize: 20)))
                            .padding(.bottom, 2)
                        
                        Button(action: {
                            // Report word as firebase analytics event
                            FirebaseAnalytics.Analytics.logEvent("report_word", parameters: [
                                "word_length": self.targetWord.joined(separator: "").count,
                                "word": self.targetWord.joined(separator: "")
                            ])

                        }) {
                            Text("Report Word").font(AppFont.regularFont(fontSize: 15))
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .leading) {
                            StatsChartView(scoreArray: self.scoreArray, currentGuess: $currentGuess, highlightDistributionBar: $highlightDistributionBar)
                        }
                        .padding()
                        .frame(width: metrics.size.width * 0.9, height: metrics.size.height / 2)
                        
                        Spacer()
                        
                        Button(action: {
                            self.newGameFunc()
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(secondaryColor)
                                    .frame(width: metrics.size.width - 100, height: 50)
                                Text("New word")
                                    .font(AppFont.regularFont(fontSize: 18))
                                    .foregroundColor(.white)
                            }
                        }
                        
                        Button(action: {
                            withAnimation(.default) {
                                self.showHome = true
                            }
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(secondaryColor)
                                    .frame(width: metrics.size.width - 100, height: 50)
                                Text("Home")
                                    .font(AppFont.regularFont(fontSize: 18))
                                    .foregroundColor(.white)
                            }
                        }
                        Spacer()
                    }.frame(width: metrics.size.width, height: metrics.size.height)
                }
            }
            .frame(width: self.width, height: self.height)
            .background(colorScheme == .dark ? darkGray : lightGray)
            .cornerRadius(30)
            .transition(.scale)
        }
    }
}

struct ShortWarningView: View {
    @Environment(\.colorScheme) var colorScheme

    @Binding var showWarningView: Bool
    @Binding var warningText: String
            
    var body: some View {
        if showWarningView {
            VStack {
                Text(self.warningText)
                    .font(AppFont.regularFont(fontSize: 20))
                    .foregroundColor(.white)
            }
            .transition(.scale)
            .frame(width: 200, height:50)
            .background(secondaryColor)
            .cornerRadius(10)
            .onAppear() {
                Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { timer in
                    self.showWarningView = false
                }
            }
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(showHome: .constant(false), wordLength: 5)
    }
}
