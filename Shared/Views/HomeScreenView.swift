//
//  HomeScreenView.swift
//  Word Guess
//
//  Created by Ben Buchanan on 2/8/22.
//

import SwiftUI

struct HomeScreenView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @Binding var showHome: Bool
    @Binding var gameMode: Int
    @Binding var showCountries: Bool
    @State var showHelp: Bool = false
    @State var showSettings: Bool = false
    @State var colorBlindMode: Bool = UserDefaults.standard.bool(forKey: "colorBlindMode")
    
    init(showHome: Binding<Bool>, gameMode: Binding<Int>, showCountries: Binding<Bool>) {
        self._showHome = showHome
        self._gameMode = gameMode
        self._showCountries = showCountries
    }
    
    var body: some View {
        print("colorBlindMode", colorBlindMode)
        // Option to choose between 4, 5, or 6 letter games
        return (
        GeometryReader { metrics in
            let cardWidth = min(400, metrics.size.width * 0.65)
            let cardSpacing = cardWidth / 15
            let fontSize = cardWidth / 8
            let cardIconSize = cardWidth / 4
            ZStack {
                ZStack {
                    Rectangle().opacity(0)
                }
                .ignoresSafeArea()
                .background(colorScheme == .dark ? Color(.systemGray6) : Color(.systemBackground))
                
                VStack {
                    HStack(alignment: .center) {
                        Button(action: {
                            withAnimation(.easeInOut) {
                                self.showSettings = true
                            }
                        }) {
                            ZStack {
                                Image(systemName: "gearshape")
                                    .font(.title)
                                    .foregroundColor(colorScheme == .dark ? .white : .black)
                                    .frame(width: 35, height: 35)
                            }.padding(.leading, 20).padding(.top, 20)
                        }
                        Spacer()
                        Button(action: {
                            withAnimation(.easeInOut) {
                                self.showHelp = true
                            }
                        }) {
                            ZStack {
                                Text("?")
                                    .font(.title)
                                    .foregroundColor(colorScheme == .dark ? .white : .black)
                                    .frame(width: 35, height: 35)
                            }.padding(.trailing, 20).padding(.top, 20)
                        }
                    }
                    .frame(maxWidth: metrics.size.width)
                    
                    Spacer()
                        .frame(height: 50)
                    
                    // TileViews to say wordguessr
                    VStack {
                        HStack {
                            TileView(tile: LetterWithStatus(letter: "W", status: Status.incorrectPlacement), overrideColor: mainColor)
                                .frame(width: metrics.size.width / 7.5, height: metrics.size.width / 7.5)
                            TileView(tile: LetterWithStatus(letter: "O", status: Status.incorrectPlacement), overrideColor: mainColor)
                                .frame(width: metrics.size.width / 7.5, height: metrics.size.width / 7.5)
                            TileView(tile: LetterWithStatus(letter: "R", status: Status.incorrectPlacement), overrideColor: mainColor)
                                .frame(width: metrics.size.width / 7.5, height: metrics.size.width / 7.5)
                            TileView(tile: LetterWithStatus(letter: "D", status: Status.incorrectPlacement), overrideColor: mainColor)
                                .frame(width: metrics.size.width / 7.5, height: metrics.size.width / 7.5)
                        }
                        HStack {
                            TileView(tile: LetterWithStatus(letter: "G", status: Status.incorrectPlacement), overrideColor: mainColor)
                                .frame(width: metrics.size.width / 7.5, height: metrics.size.width / 7.5)
                            TileView(tile: LetterWithStatus(letter: "U", status: Status.incorrectPlacement), overrideColor: mainColor)
                                .frame(width: metrics.size.width / 7.5, height: metrics.size.width / 7.5)
                            TileView(tile: LetterWithStatus(letter: "E", status: Status.incorrectPlacement), overrideColor: mainColor)
                                .frame(width: metrics.size.width / 7.5, height: metrics.size.width / 7.5)
                            TileView(tile: LetterWithStatus(letter: "S", status: Status.incorrectPlacement), overrideColor: mainColor)
                                .frame(width: metrics.size.width / 7.5, height: metrics.size.width / 7.5)
                            TileView(tile: LetterWithStatus(letter: "S", status: Status.incorrectPlacement), overrideColor: mainColor)
                                .frame(width: metrics.size.width / 7.5, height: metrics.size.width / 7.5)
                            TileView(tile: LetterWithStatus(letter: "R", status: Status.incorrectPlacement), overrideColor: mainColor)
                                .frame(width: metrics.size.width / 7.5, height: metrics.size.width / 7.5)
                        }
                    }
                    
                    Spacer()
                    
                    // ScrollView of game cards
                    ScrollViewReader { value in
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: cardSpacing) {
                                
                                // Four Letters card
                                GeometryReader { geo in
                                    let shouldScaleDown = geo.frame(in: .global).minX - metrics.frame(in: .global).minX < 0 || metrics.frame(in: .global).maxX - geo.frame(in: .global).maxX < 0
                                    GameCardView(gameMode: 4, cardText: "Four Letters", cardWidth: cardWidth, fontSize: fontSize, cardBackgroundColor: fourGradient, detailView: AnyView(
                                        Text("4")
                                            .font(AppFont.boldFont(fontSize: cardIconSize))
                                            .foregroundColor(.white)
                                            .frame(width: cardIconSize, height: cardIconSize)
                                            .padding()
                                    ), cardPressedFunc: {
                                        self.showCountries = false
                                        self.gameMode = 4
                                        withAnimation(.default) {
                                            self.showHome = false
                                        }
                                    })
                                    .id(0)
                                    .scaleEffect(x: 1, y: shouldScaleDown ? 0.9 : 1)
                                    .shadow(color: colorScheme == .dark ? Color(.systemGray4) : Color(.lightGray), radius: !shouldScaleDown ? 20 : 0, x: 0, y: !shouldScaleDown ? 10 : 0)
                                    .animation(.easeInOut(duration: 0.25), value: shouldScaleDown)
                                }.frame(width: cardWidth)
                                
                                // Five Letters card
                                GeometryReader { geo in
                                    let shouldScaleDown = geo.frame(in: .global).minX - metrics.frame(in: .global).minX < 0 || metrics.frame(in: .global).maxX - geo.frame(in: .global).maxX < 0
                                    GameCardView(gameMode: self.gameMode, cardText: "Five Letters", cardWidth: cardWidth, fontSize: fontSize, cardBackgroundColor: fiveGradient, detailView: AnyView(
                                        Text("5")
                                            .font(AppFont.boldFont(fontSize: cardIconSize))
                                            .foregroundColor(.white)
                                            .frame(width: cardIconSize, height: cardIconSize)
                                            .padding()
                                    ), cardPressedFunc: {
                                        self.showCountries = false
                                        self.gameMode = 5
                                        withAnimation(.default) {
                                            self.showHome = false
                                        }
                                    })
                                    .id(1)
                                    .scaleEffect(x: 1, y: shouldScaleDown ? 0.9 : 1)
                                    .shadow(color: colorScheme == .dark ? Color(.systemGray4) : Color(.lightGray), radius: !shouldScaleDown ? 20 : 0, x: 0, y: !shouldScaleDown ? 10 : 0)
                                    .animation(.easeInOut(duration: 0.25), value: shouldScaleDown)
                                }.frame(width: cardWidth)

                                
                                // Six Letters card
                                GeometryReader { geo in
                                    let shouldScaleDown = geo.frame(in: .global).minX - metrics.frame(in: .global).minX < 0 || metrics.frame(in: .global).maxX - geo.frame(in: .global).maxX < 0
                                    GameCardView(gameMode: self.gameMode, cardText: "Six Letters", cardWidth: cardWidth, fontSize: fontSize, cardBackgroundColor: sixGradient, detailView: AnyView(
                                        Text("6")
                                            .font(AppFont.boldFont(fontSize: cardIconSize))
                                            .foregroundColor(.white)
                                            .frame(width: cardIconSize, height: cardIconSize)
                                            .padding()
                                    ), cardPressedFunc: {
                                        self.showCountries = false
                                        self.gameMode = 6
                                        withAnimation(.default) {
                                            self.showHome = false
                                        }
                                    })
                                    .id(2)
                                    .scaleEffect(x: 1, y: shouldScaleDown ? 0.9 : 1)
                                    .shadow(color: colorScheme == .dark ? Color(.systemGray4) : Color(.lightGray), radius: !shouldScaleDown ? 20 : 0, x: 0, y: !shouldScaleDown ? 10 : 0)
                                    .animation(.easeInOut(duration: 0.25), value: shouldScaleDown)
                                }.frame(width: cardWidth)
                                
                                // Countries card
                                GeometryReader { geo in
                                    let shouldScaleDown = geo.frame(in: .global).minX - metrics.frame(in: .global).minX < 0 || metrics.frame(in: .global).maxX - geo.frame(in: .global).maxX < 0
                                    GameCardView(gameMode: self.gameMode, cardText: "Countries", cardWidth: cardWidth, fontSize: fontSize, cardBackgroundColor: countriesGradient, detailView: AnyView(
                                        Image(systemName: "globe.americas")
                                            .resizable()
                                            .foregroundColor(.white)
                                            .font(.system(size: cardIconSize))
                                            .frame(width: cardIconSize, height: cardIconSize)
                                            .padding()
                                    ), cardPressedFunc: {
                                        withAnimation(.default) {
                                            self.showHome = false
                                            self.showCountries = true
                                        }
                                    })
                                    .id(3)
                                    .scaleEffect(x: 1, y: shouldScaleDown ? 0.9 : 1)
                                    .shadow(color: colorScheme == .dark ? Color(.systemGray4) : Color(.lightGray), radius: !shouldScaleDown ? 20 : 0, x: 0, y: !shouldScaleDown ? 10 : 0)
                                    .animation(.easeInOut(duration: 0.25), value: shouldScaleDown)
                                }.frame(width: cardWidth)
                            }
                            .frame(height: metrics.size.height * 0.4)
                            .padding(.vertical, 50)
                            .padding(.horizontal, (metrics.size.width / 2) - (cardWidth / 2))
                            .onAppear() {
                                value.scrollTo(1, anchor: .center)
                            }
                        }
                    }
                    .frame(height: metrics.size.height * 0.4)
                    
                    Spacer()
                        .frame(height: 50)
                }
                .frame(height: metrics.size.height)
                
                HelpView(showHelp: $showHelp)
                SettingsView(showSettings: $showSettings, colorBlindMode: $colorBlindMode)
                
            }.frame(width: metrics.size.width, height: metrics.size.height)
        })
    }
}

struct GameCardView: View {
    
    @State var gameMode: Int
    @State var cardText: String
    @State var cardWidth: CGFloat
    @State var fontSize: CGFloat
    @State var cardBackgroundColor: LinearGradient
    @State var detailView: AnyView
    
    var cardPressedFunc: () -> Void
    
    var body: some View {
        Button(action: {
            self.cardPressedFunc()
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(self.cardBackgroundColor)
                VStack(alignment: .leading) {
                    HStack {
                        Spacer()
                        self.detailView
                    }
                    Spacer()
                    Text(self.cardText)
                        .font(AppFont.boldFont(fontSize: self.fontSize))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                        .padding()
                }
            }
        }
        .frame(width: self.cardWidth)
    }
}

struct HelpView: View {
    @Environment(\.colorScheme) var colorScheme

    @Binding var showHelp: Bool
    
    @State private var dragAddition: CGFloat = 0
    let dragLimit: CGFloat = 50
    
    var body: some View {
        // Dim background for the game over screen
        GeometryReader { metrics in
            ZStack(alignment: .bottom) {
                if self.showHelp {
                    Color.black
                        .opacity(0.7)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation(.easeInOut) {
                                self.showHelp = false
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
                                                    self.showHelp.toggle()
                                                }
                                            }
                                    )
                                    
                                    Spacer()
                                    VStack(alignment: .leading, spacing: 0) {
                                        Text("Guess the word in six attempts. Hit the \"Enter\" button to submit your guess.")
                                            .font(.system(size: 20).weight(.medium))
                                            .padding(10)
                                            .minimumScaleFactor(0.5)
                                        Text("The tiles will change colors after each guess to show you how close you are to the correct word.")
                                            .font(.system(size: 20).weight(.medium))
                                            .padding(10)
                                            .minimumScaleFactor(0.5)
                                    }
                                    
                                    Spacer()
                                    
                                    VStack(alignment: .center) {
                                        HStack {
                                            TileView(tile: LetterWithStatus(letter: "R", status: Status.correct))
                                                .frame(width: metrics.size.width / 7, height: metrics.size.width / 7)
                                            TileView(tile: LetterWithStatus(letter: "O", status: Status.normal))
                                                .frame(width: metrics.size.width / 7, height: metrics.size.width / 7)
                                            TileView(tile: LetterWithStatus(letter: "U", status: Status.normal))
                                                .frame(width: metrics.size.width / 7, height: metrics.size.width / 7)
                                            TileView(tile: LetterWithStatus(letter: "T", status: Status.normal))
                                                .frame(width: metrics.size.width / 7, height: metrics.size.width / 7)
                                            TileView(tile: LetterWithStatus(letter: "E", status: Status.normal))
                                                .frame(width: metrics.size.width / 7, height: metrics.size.width / 7)
                                            
                                        }
                                        Text("The **R** is in the correct position.")
                                            .font(.system(size: 16))
                                            .padding(.bottom, 10)
                                    }
                                    
                                    VStack(alignment: .center) {
                                        HStack {
                                            TileView(tile: LetterWithStatus(letter: "P", status: Status.normal))
                                                .frame(width: metrics.size.width / 7, height: metrics.size.width / 7)
                                            TileView(tile: LetterWithStatus(letter: "L", status: Status.incorrectPlacement))
                                                .frame(width: metrics.size.width / 7, height: metrics.size.width / 7)
                                            TileView(tile: LetterWithStatus(letter: "A", status: Status.normal))
                                                .frame(width: metrics.size.width / 7, height: metrics.size.width / 7)
                                            TileView(tile: LetterWithStatus(letter: "C", status: Status.normal))
                                                .frame(width: metrics.size.width / 7, height: metrics.size.width / 7)
                                            TileView(tile: LetterWithStatus(letter: "E", status: Status.normal))
                                                .frame(width: metrics.size.width / 7, height: metrics.size.width / 7)
                                            
                                        }
                                        Text("The **L** is in the word but in the wrong position.")
                                            .font(.system(size: 16))
                                            .padding(.bottom, 10)
                                    }
                                    
                                    VStack(alignment: .center) {
                                        HStack {
                                            TileView(tile: LetterWithStatus(letter: "M", status: Status.normal))
                                                .frame(width: metrics.size.width / 7, height: metrics.size.width / 7)
                                            TileView(tile: LetterWithStatus(letter: "E", status: Status.normal))
                                                .frame(width: metrics.size.width / 7, height: metrics.size.width / 7)
                                            TileView(tile: LetterWithStatus(letter: "A", status: Status.incorrect))
                                                .frame(width: metrics.size.width / 7, height: metrics.size.width / 7)
                                            TileView(tile: LetterWithStatus(letter: "N", status: Status.normal))
                                                .frame(width: metrics.size.width / 7, height: metrics.size.width / 7)
                                            TileView(tile: LetterWithStatus(letter: "S", status: Status.normal))
                                                .frame(width: metrics.size.width / 7, height: metrics.size.width / 7)
                                            
                                        }
                                        Text("The **A** is not in the word at all")
                                            .font(.system(size: 16))
                                            .padding(.bottom, 10)
                                    }
                                    Spacer()
                                }
                                .padding(.horizontal, 5)
                                .frame(width: geo.size.width * 0.9)
                            }
                            .frame(width: geo.size.width, height: geo.size.height)
                        }
                    }
                    .frame(height: metrics.size.height * 0.8 + dragAddition)
                    .background(colorScheme == .dark ? Color(.systemGray5) : Color(.systemBackground))
                    .cornerRadius(15, corners: [.topLeft, .topRight])
                    .transition(.move(edge: .bottom))
                    .gesture(swipeGesture)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            .ignoresSafeArea()
        }
    }
    
    @State private var prevDragTranslation = CGSize.zero
    
    var dragGesture: some Gesture {
        return DragGesture(minimumDistance: 0, coordinateSpace: .global)
            .onChanged { val in
                let dragAmount = val.translation.height - prevDragTranslation.height
                if dragAmount < 0 {
                    dragAddition -= dragAmount / 10
                } else {
                    dragAddition -= dragAmount / 10
                }
                prevDragTranslation = val.translation
            }
            .onEnded { val in
                withAnimation(.easeInOut) {
                    if dragAddition < 0 {
                        self.showHelp = false
                    }
                }
                prevDragTranslation = .zero
                withAnimation(.easeInOut(duration: 0.15)) {
                    dragAddition = 0
                }
            }
    }
    
    var swipeGesture: some Gesture {
        return DragGesture(minimumDistance: 0, coordinateSpace: .local)
            .onEnded { val in
                if val.translation.height > 0 {
                    // This is a swipe down
                    withAnimation(.easeInOut) {
                        self.showHelp = false
                    }
                }
            }
    }
}

struct SettingsView: View {
    @Environment(\.colorScheme) var colorScheme

    @Binding var showSettings: Bool
    @Binding var colorBlindMode: Bool
    
    @State private var dragAddition: CGFloat = 0
    let dragLimit: CGFloat = 50
    
    var body: some View {
        // Dim background for the game over screen
        GeometryReader { metrics in
            ZStack(alignment: .bottom) {
                if self.showSettings {
                    Color.black
                        .opacity(0.7)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation(.easeInOut) {
                                self.showSettings = false
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
                                    .contentShape(Rectangle())
                                    .gesture(dragGesture)
                                    .simultaneousGesture(
                                        TapGesture()
                                            .onEnded {
                                                withAnimation(.easeInOut) {
                                                    self.showSettings.toggle()
                                                }
                                            }
                                    )
                                    
                                    VStack(alignment: .leading) {
                                        Text("Settings")
                                            .font(.largeTitle).fontWeight(.medium)
                                            .padding(.bottom)
                                        Toggle(isOn: $colorBlindMode, label: {
                                            Text("Color blind mode")
                                                .font(.title3)
                                        })
                                        .onChange(of: self.colorBlindMode) { value in
                                                UserDefaults.standard.set(value, forKey: "colorBlindMode")
                                        }
                                        Spacer()
                                    }
                                    .frame(width: geo.size.width * 0.9, alignment: .leading)
                                    
                                    Spacer()
                                }
                                .padding(.horizontal, 5)
                                .frame(width: geo.size.width * 0.9)
                            }
                            .frame(width: geo.size.width, height: geo.size.height)
                        }
                    }
                    .frame(height: metrics.size.height * 0.5 + dragAddition)
                    .background(colorScheme == .dark ? Color(.systemGray5) : Color(.systemBackground))
                    .cornerRadius(15, corners: [.topLeft, .topRight])
                    .transition(.move(edge: .bottom))
                    .onTapGesture {}
                    .gesture(swipeGesture)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            .ignoresSafeArea()
        }
    }
    
    @State private var prevDragTranslation = CGSize.zero
    
    var dragGesture: some Gesture {
        return DragGesture(minimumDistance: 0, coordinateSpace: .global)
            .onChanged { val in
                let dragAmount = val.translation.height - prevDragTranslation.height
                if dragAmount < 0 {
                    dragAddition -= dragAmount / 10
                } else {
                    dragAddition -= dragAmount / 10
                }
                prevDragTranslation = val.translation
            }
            .onEnded { val in
                withAnimation(.easeInOut) {
                    if dragAddition < 0 {
                        self.showSettings = false
                    }
                }
                prevDragTranslation = .zero
                withAnimation(.easeInOut(duration: 0.15)) {
                    dragAddition = 0
                }
            }
    }
    
    var swipeGesture: some Gesture {
        return DragGesture(minimumDistance: 0, coordinateSpace: .local)
            .onEnded { val in
                if val.translation.height > 0 {
                    // This is a swipe down
                    withAnimation(.easeInOut) {
                        self.showSettings = false
                    }
                }
            }
    }
}


struct HomeScreenView_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreenView(showHome: .constant(true), gameMode: .constant(5), showCountries: .constant(false))
    }
}
