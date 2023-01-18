//
//  GameView.swift
//  Word Guess
//
//  Created by Ben Buchanan on 2/8/22.
//

import SwiftUI
import Firebase
import FirebaseAnalytics

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
    @State var scoreArray: [Int]
    @State var highlightDistributionBar: Bool = true
    @State var showDistribution: Bool = false
    @State var wordReported: Bool = false
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
                            ForEach(0...5, id: \.self) { i in
                                HStack {
                                    Spacer()
                                    HStack(spacing: 5) {
                                        ForEach(0...self.wordLength - 1, id: \.self) { j in
                                            TileView(tile: self.guesses[i][j])
                                                .frame(width: min(gtest.size.height / 6.5, gtest.size.width / CGFloat(self.wordLength + 1)), height: min(gtest.size.height / 6.5, gtest.size.width / CGFloat(self.wordLength + 1)))
                                        }
                                    }
                                    Spacer()
                                }
                            }
                        }
                    }
                    Spacer()
                    
                    // Keyboard
                    Spacer()
                    VStack(spacing: 10) {
                        HStack(spacing: 5) {
                            ForEach(0...9, id: \.self) { i in
                                KeyboardLetterView(kbLetter: self.keyboardLetters[i], width: metrics.size.width / 11.5, fontSize: metrics.size.width / 25).onTapGesture {
                                    inputLetter(letter: self.keyboardLetters[i].letter)
                                }
                            }
                        }
                        HStack(spacing: 5) {
                            ForEach(10...18, id: \.self) { i in
                                KeyboardLetterView(kbLetter: self.keyboardLetters[i], width: metrics.size.width / 11.5, fontSize: metrics.size.width / 25).onTapGesture {
                                    inputLetter(letter: self.keyboardLetters[i].letter)
                                }
                            }
                        }
                        HStack(spacing: 5) {
                            Button(action: submitGuess) {
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
                                    inputLetter(letter: self.keyboardLetters[i].letter)
                                }
                            }
                            Button(action: deleteLetter) {
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
                
                DistributionView(scoreArray: self.$scoreArray, currentGuess: self.$currentGuess, showDistribution: self.$showDistribution)
                
                GameOverView(showGameOver: $showGameOver, gameOverTitleText: $gameOverTitleText, targetWord: $targetWord, showHome: $showHome, scoreArray: $scoreArray, currentGuess: $currentGuess, highlightDistributionBar: $highlightDistributionBar, width: metrics.size.width - 50, height: metrics.size.height - 150, wordReported: $wordReported, newGameFunc: startNewGame)
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
            for i in 0..<self.guesses[self.currentGuess].count {
                withAnimation(.default) {
                    self.guesses[self.currentGuess][i].submittedIncorrectly += 1
                }
            }
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
                if i+1 == self.wordLength {
                    let isValidGuess = isValidGuess(guess: self.guesses[self.currentGuess])
                    if !isValidGuess.0 {
                        for j in 0..<self.guesses[self.currentGuess].count {
                            self.guesses[self.currentGuess][j].invalid = true
                        }
                    }
                }
                return
            }
        }
    }
    
    func deleteLetter() {
        for i in 0..<self.guesses[self.currentGuess].count {
            self.guesses[self.currentGuess][i].invalid = false
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

struct DistributionView: View {
    @Environment(\.colorScheme) var colorScheme

    @Binding var scoreArray: [Int]
    @Binding var currentGuess: Int
    @Binding var showDistribution: Bool
    
    @State private var curHeight: CGFloat = 500
    let heightLimit: CGFloat = 500
    
    var body: some View {
        // Dim background for the game over screen
        ZStack(alignment: .bottom) {
            if self.showDistribution {
                Color.black
                    .opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.easeInOut) {
                            self.showDistribution = false
                        }
                    }
                ZStack {
                    GeometryReader { geo in
                        ZStack {
                            VStack {
                                ZStack {
                                    Capsule()
                                        .frame(width: 40, height: 5)
                                        .padding()
                                }
                                .frame(height: 40)
                                .frame(maxWidth: .infinity)
                                .gesture(dragGesture)
                                Spacer()
                            }
                            VStack(alignment: .leading) {
                                StatsChartView(scoreArray: self.scoreArray, currentGuess: $currentGuess, highlightDistributionBar: .constant(false), viewWidth: geo.size.width)
                            }
                            .padding(.horizontal, 5)
                            .frame(width: geo.size.width * 0.9, height: geo.size.height * 0.8)
                        }
                        .frame(width: geo.size.width, height: geo.size.height)
                    }
                }
                .frame(height: curHeight)
                .background(colorScheme == .dark ? Color(.systemGray5) : Color(.systemBackground))
                .cornerRadius(20)
                .transition(.move(edge: .bottom))
                .gesture(swipeGesture)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .ignoresSafeArea()
    }
    
    @State private var prevDragTranslation = CGSize.zero
    
    var dragGesture: some Gesture {
        DragGesture(minimumDistance: 0, coordinateSpace: .global)
            .onChanged { val in
                let dragAmount = val.translation.height - prevDragTranslation.height
                if curHeight > heightLimit || curHeight < heightLimit {
                    curHeight -= dragAmount / 6
                } else {
                    curHeight -= dragAmount
                }
                prevDragTranslation = val.translation
            }
            .onEnded { val in
                withAnimation(.easeInOut) {
                    if curHeight < heightLimit {
                        self.showDistribution = false
                    }
                }
                prevDragTranslation = .zero
                withAnimation(.easeInOut(duration: 0.15)) {
                    curHeight = heightLimit
                }
            }
    }
    
    var swipeGesture: some Gesture {
        DragGesture(minimumDistance: 0, coordinateSpace: .local)
            .onEnded { val in
                if val.translation.height > 0 {
                    withAnimation(.easeInOut) {
                        self.showDistribution = false
                    }
                }
            }
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
    @Binding var wordReported: Bool
    var newGameFunc: () -> Void
    
    @State private var minimizeGameOver: Bool = false
    @State private var dragAddition: CGFloat = 0
    let dragLimit: CGFloat = 50
    
    var body: some View {
        // Dim background for the game over screen
        GeometryReader { metrics in
            ZStack(alignment: .bottom) {
                if self.showGameOver {
                    if !self.minimizeGameOver {
                        Color.black
                            .opacity(0.3)
                            .ignoresSafeArea()
                            .onTapGesture {
                                withAnimation(.easeInOut) {
                                    self.minimizeGameOver = true
                                }
                            }
                    }
                    ZStack {
                        GeometryReader { geo in
                            ZStack {
                                VStack() {
                                    ZStack {
                                        Capsule()
                                            .frame(width: 40, height: 5)
                                            .padding()
                                    }
                                    .frame(height: 40)
                                    .frame(maxWidth: .infinity)
                                    .contentShape(Rectangle())
                                    .gesture(dragGesture)
                                    .simultaneousGesture(
                                        TapGesture()
                                            .onEnded {
                                                withAnimation(.easeInOut) {
                                                    self.minimizeGameOver.toggle()
                                                }
                                            }
                                    )
                                    
                                    if !self.minimizeGameOver {
                                        
                                        Text(self.gameOverTitleText)
                                            .font(.system(.title))
                                            .foregroundColor(colorScheme == .dark ? .white : .black)
                                            .padding(.bottom, 10)
                                        
                                        (Text("The word was ")
                                            .font(.system(.title3))
                                            .foregroundColor(colorScheme == .dark ? .white : .black)
                                         + Text(self.targetWord.joined(separator: ""))
                                            .font(.system(.title3).weight(.bold)))
                                        .padding(.bottom, 2)
                                        
                                        Button(action: {
                                            // Report word as firebase analytics event
                                            FirebaseAnalytics.Analytics.logEvent("report_word", parameters: [
                                                "word_length": self.targetWord.joined(separator: "").count,
                                                "word": self.targetWord.joined(separator: "")
                                            ])
                                            
                                            self.wordReported = true
                                            
                                        }) {
                                            Text("Report Word").font(.system(.caption))
                                        }
                                        .disabled(self.wordReported)
                                        
                                        StatsChartView(scoreArray: self.scoreArray, currentGuess: $currentGuess, highlightDistributionBar: $highlightDistributionBar, viewWidth: geo.size.width)
                                            .padding(.vertical)
                                    }
                                    
                                    HStack(spacing: 0) {
                                        Button(action: {
                                            withAnimation(.default) {
                                                self.wordReported = false
                                                self.minimizeGameOver = false
                                                self.showHome = true
                                            }
                                        }) {
                                            ZStack {
                                                Rectangle()
                                                    .fill(mainColor)
                                                    .frame(width: metrics.size.width / 2, height: metrics.size.height / 10)
                                                Text("Home")
                                                    .font(.system(.title2).weight(.semibold))
                                                    .foregroundColor(.white)
                                            }
                                        }
                                        
                                        Rectangle()
                                            .fill(.white)
                                            .frame(width: 1, height: metrics.size.height / 10)
                                        
                                        Button(action: {
                                            self.wordReported = false
                                            self.newGameFunc()
                                            self.minimizeGameOver = false
                                        }) {
                                            ZStack {
                                                Rectangle()
                                                    .fill(mainColor)
                                                    .frame(width: metrics.size.width / 2, height: metrics.size.height / 10)
                                                Text("New word")
                                                    .font(.system(.title2).weight(.semibold))
                                                    .foregroundColor(.white)
                                            }
                                        }
                                    }
                                }
                                .padding(.horizontal, 5)
                                .frame(width: geo.size.width * 0.9)
                            }
                            .frame(width: geo.size.width, height: geo.size.height)
                        }
                    }
                    .frame(height: self.minimizeGameOver ? metrics.size.height * 0.15 : metrics.size.height * 0.7 + dragAddition)
                    .background(colorScheme == .dark ? Color(.systemGray5) : Color(.systemBackground))
                    .cornerRadius(15, corners: [.topLeft, .topRight])
                    .transition(.move(edge: .bottom))
                    .gesture(swipeGesture)
                    .shadow(color: darkGrayBackgroundColor, radius: self.minimizeGameOver ? 20 : 0)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            .ignoresSafeArea()
        }
    }
    
    @State private var prevDragTranslation = CGSize.zero
    
    var dragGesture: some Gesture {
        if self.minimizeGameOver {
            return DragGesture(minimumDistance: 0, coordinateSpace: .global)
                .onChanged { val in
                    let dragAmount = val.translation.height - prevDragTranslation.height
                    if dragAmount < 0 {
                        dragAddition -= dragAmount / 6
                    }
                    prevDragTranslation = val.translation
                }
                .onEnded { val in
                    withAnimation(.easeInOut) {
                        if dragAddition > 0 {
                            self.minimizeGameOver = false
                        }
                    }
                    prevDragTranslation = .zero
                    withAnimation(.easeInOut(duration: 0.15)) {
                        dragAddition = 0
                    }
                }
        } else {
            return DragGesture(minimumDistance: 0, coordinateSpace: .global)
                .onChanged { val in
                    let dragAmount = val.translation.height - prevDragTranslation.height
                    if abs(dragAddition) > dragLimit {
                        dragAddition -= dragAmount / 6
                    } else {
                        dragAddition -= dragAmount
                    }
                    prevDragTranslation = val.translation
                }
                .onEnded { val in
                    withAnimation(.easeInOut) {
                        if dragAddition < 0 {
                            self.minimizeGameOver = true
                        }
                    }
                    prevDragTranslation = .zero
                    withAnimation(.easeInOut(duration: 0.15)) {
                        dragAddition = 0
                    }
                }
        }
    }
    
    var swipeGesture: some Gesture {
        if self.minimizeGameOver {
            return DragGesture(minimumDistance: 0, coordinateSpace: .local)
                .onEnded { val in
                    if val.translation.height < 0 {
                        // This is a swipe up
                        withAnimation(.easeInOut) {
                            self.minimizeGameOver = false
                        }
                    }
                }
        } else {
            return DragGesture(minimumDistance: 0, coordinateSpace: .local)
                .onEnded { val in
                    if val.translation.height > 0 {
                        // This is a swipe down
                        withAnimation(.easeInOut) {
                            self.minimizeGameOver = true
                        }
                    }
                }
        }
        
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}


struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(showHome: .constant(false), wordLength: 5)
    }
}
