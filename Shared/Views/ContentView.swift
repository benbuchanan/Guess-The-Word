//
//  ContentView.swift
//  Shared
//
//  Created by Ben Buchanan on 1/30/22.
//

import SwiftUI
import Firebase

struct ContentView: View {
    
    // TODO: support 4 letter and 6 letter games as well
    // Need to get word lists for those games
    // Have home screen where they pick the game mode
    // Have hints that people can buy
    // Winning games gives hints but also purchaseable
    
    @Environment(\.colorScheme) var colorScheme
    
    // Increment on 'Enter'
    @State var showHome: Bool = true
    @State var showCountries: Bool = false
    @State var gameMode: Int = 5
    
    init() {
      FirebaseApp.configure()
    }
        
    var body: some View {
        if self.showHome {
            HomeScreenView(showHome: $showHome, gameMode: $gameMode, showCountries: $showCountries)
        } else if showCountries {
            CountryView(showHome: $showHome)
        } else {
            GameView(showHome: $showHome, wordLength: self.gameMode)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
