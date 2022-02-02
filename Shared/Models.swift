//
//  Models.swift
//  Word Guess
//
//  Created by Ben Buchanan on 2/2/22.
//
import SwiftUI

struct LetterWithStatus {
    var letter: String
    var status: Status
}

enum Status: String {
    case normal = "normal"
    case correct = "correct"
    case incorrectPlacement = "incorrect_placement"
    case incorrect = "incorrect"
}

var lightGray: Color = Color(red: 215/255, green: 215/255, blue: 215/255)
var darkGray: Color = Color(red: 130/255, green: 130/255, blue: 130/255)
var lightIncorrect: Color = Color(red: 120/255, green: 125/255, blue: 125/255)
var darkDark: Color = Color(red: 60/255, green: 60/255, blue: 60/255)
var darkBorder: Color = Color(red: 85/255, green: 85/255, blue: 85/255)
var lightBorder: Color = Color(red: 135/255, green: 140/255, blue: 140/255)
