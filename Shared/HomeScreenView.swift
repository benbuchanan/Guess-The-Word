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
    
    var body: some View {
        // Option to choose between 4, 5, or 6 letter games
        GeometryReader { metrics in
            ZStack {
                VStack {
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
            }.frame(width: metrics.size.width, height: metrics.size.height)
        }
    }
}

struct HomeScreenView_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreenView(showHome: .constant(true), gameMode: .constant(5))
    }
}
