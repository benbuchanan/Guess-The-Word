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
    @Binding var gameMode: GameMode
    
    var body: some View {
        // Option to choose between 4, 5, or 6 letter games
        ZStack {
            VStack {
                Spacer()
                Text("Guess that word").font(.title)
                Spacer()
                VStack {
                    Button(action: {
                        self.gameMode = GameMode.four
                        self.showHome = false
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 25)
                                .fill(incorrectPlacementColor)
                                .frame(width: 300, height: 50)
                            Text("4 Letters").foregroundColor(.white)
                        }
                    }
                    Button(action: {
                        self.gameMode = GameMode.five
                        self.showHome = false
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 25)
                                .fill(incorrectPlacementColor)
                                .frame(width: 300, height: 50)
                            Text("5 Letters").foregroundColor(.white)
                        }
                    }
                    Button(action: {
                        self.gameMode = GameMode.six
                        self.showHome = false
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 25)
                                .fill(incorrectPlacementColor)
                                .frame(width: 300, height: 50)
                            Text("6 Letters").foregroundColor(.white)
                        }
                    }
                }
                Spacer()
            }
        }
    }
}

struct HomeScreenView_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreenView(showHome: .constant(true), gameMode: .constant(GameMode.five))
    }
}
