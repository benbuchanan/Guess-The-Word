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
    @State var showHelp: Bool = false
    
    var body: some View {
        // Option to choose between 4, 5, or 6 letter games
        GeometryReader { metrics in
            ZStack {
                VStack {
                    HStack {
                        Spacer()
                        Button(action: {
                            withAnimation(.default) {
                                self.showHelp = true
                            }
                        }) {
                            ZStack {
                                Circle()
                                    .fill(colorScheme == .dark ? darkGray : lightGray)
                                    .frame(width: 35, height: 35)
                                Text("?")
                                    .font(.title2)
                                    .foregroundColor(colorScheme == .dark ? .white : .black)
                                    .frame(width: 20, height: 20)
                            }.padding(.trailing, 20)
                        }
                    }
                    Spacer()
//                    Text("WordGuessr").font(.largeTitle)
                    Image("WordGuessrLogo2")
                        .resizable()
                        .frame(width: metrics.size.width, height: metrics.size.width)
                    Spacer()
                    VStack {
                        Button(action: {
                            self.gameMode = 4
                            withAnimation(.default) {
                                self.showHome = false
                            }
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 50)
                                    .fill(secondaryColor)
                                    .frame(width: metrics.size.width - 100, height: 60)
                                Text("Four Letters")
                                    .font(AppFont.regularFont(fontSize: 20))
                                    .foregroundColor(.white)
                            }
                        }
                        Button(action: {
                            self.gameMode = 5
                            withAnimation(.default) {
                                self.showHome = false
                            }
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 50)
                                    .fill(secondaryColor)
                                    .frame(width: metrics.size.width - 100, height: 60)
                                Text("Five Letters")
                                    .font(AppFont.regularFont(fontSize: 20))
                                    .foregroundColor(.white)
                            }
                        }.padding(10)
                        Button(action: {
                            self.gameMode = 6
                            withAnimation(.default) {
                                self.showHome = false
                            }
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 50)
                                    .fill(secondaryColor)
                                    .frame(width: metrics.size.width - 100, height: 60)
                                Text("Six Letters")
                                    .font(AppFont.regularFont(fontSize: 20))
                                    .foregroundColor(.white)
                            }
                        }.padding(.bottom, 40)
                    }
                }
                
                // Dim background for the help screen
                if self.showHelp {
                    Color.black
                        .opacity(0.6)
                        .ignoresSafeArea()
                        .onTapGesture {
                            self.showHelp = false
                        }
                }
                
                HelpView(showHelp: $showHelp, width: metrics.size.width - 50, height: metrics.size.height - 150)
                
            }.frame(width: metrics.size.width, height: metrics.size.height)
        }
    }
}

struct HelpView: View {
    @Environment(\.colorScheme) var colorScheme

    @Binding var showHelp: Bool
    @State var width: CGFloat
    @State var height: CGFloat
    
    var body: some View {
        if showHelp {
            ZStack {
                GeometryReader { metrics in
                    ZStack {
                        VStack {
                            HStack {
                                Spacer()
                                Button(action: {
                                    self.showHelp = false
                                }) {
                                    ZStack {
                                        Circle()
                                            .fill(darkDark)
                                            .frame(width: 35, height: 35)
                                        Text("X")
    //                                        .font(.title2)
                                            .font(AppFont.mediumFont(fontSize: 20))
                                            .foregroundColor(.white)
                                            .frame(width: 20, height: 20)
                                    }.padding(20)
                                }
                            }
                            Spacer()
                        }
                    }
                    VStack {
                        Spacer()
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Guess the word in six attempts. Hit the \"Enter\" button to submit your guess.")
                                .font(AppFont.regularFont(fontSize: 16))
                                .padding(10)
                            Text("The tiles will change colors after each guess to show you how close you are to the correct word.")
                                .font(AppFont.regularFont(fontSize: 16))
                                .padding(10)
                        }.padding(.bottom)
                                                
                        VStack(alignment: .leading) {
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
                                .font(AppFont.regularFont(fontSize: 16))
                                .padding(.bottom, 10)
                        }
                        
                        VStack(alignment: .leading) {
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
                                .font(AppFont.regularFont(fontSize: 16))
                                .padding(.bottom, 10)
                        }
                        
                        VStack(alignment: .leading) {
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
                            Text("The **A** is not in the word at all.")
                                .font(AppFont.regularFont(fontSize: 16))
                                .padding(.bottom, 10)
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

struct HomeScreenView_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreenView(showHome: .constant(true), gameMode: .constant(5))
    }
}
