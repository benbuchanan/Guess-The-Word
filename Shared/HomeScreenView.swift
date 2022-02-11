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
                    Text("Guess that word").font(.largeTitle)
                    Spacer()
                    VStack {
                        Button(action: {
                            self.gameMode = 4
                            withAnimation(.default) {
                                self.showHome = false
                            }
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 25)
                                    .fill(incorrectPlacementColor)
                                    .frame(width: metrics.size.width - 100, height: 100)
                                Text("4 Letters")
                                    .font(.title)
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
                                RoundedRectangle(cornerRadius: 25)
                                    .fill(incorrectPlacementColor)
                                    .frame(width: metrics.size.width - 100, height: 100)
                                Text("5 Letters")
                                    .font(.title)
                                    .foregroundColor(.white)
                            }
                        }
                        Button(action: {
                            self.gameMode = 6
                            withAnimation(.default) {
                                self.showHome = false
                            }
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 25)
                                    .fill(incorrectPlacementColor)
                                    .frame(width: metrics.size.width - 100, height: 100)
                                Text("6 Letters")
                                    .font(.title)
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    Spacer()
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
