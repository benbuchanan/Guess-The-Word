//
//  Consts.swift
//  Word Guess
//
//  Created by Ben Buchanan on 2/26/22.
//

import SwiftUI

let earthRadiusInKm: Double = 6378.8

var lightGray: Color = Color(red: 215/255, green: 215/255, blue: 215/255)
var darkGray: Color = Color(red: 130/255, green: 130/255, blue: 130/255)
var lightIncorrect: Color = Color(red: 120/255, green: 125/255, blue: 125/255)
var darkDark: Color = Color(red: 60/255, green: 60/255, blue: 60/255)
var darkBorder: Color = Color(red: 85/255, green: 85/255, blue: 85/255)
var lightBorder: Color = Color(red: 135/255, green: 140/255, blue: 140/255)
var mainColor: Color = Color(red: 0/255, green: 150/255, blue: 255/255)
var secondaryColor: Color = Color(red: 0/255, green: 71/255, blue: 171/255)
var palette1: Color = Color(red: 0/255, green: 150/255, blue: 255/255)
var palette2: Color = Color(red: 0/255, green: 12/255, blue: 91/255)
var palette3: Color = Color(red: 132/255, green: 132/255, blue: 255/255)
var palette4: Color = Color(red: 0/255, green: 38/255, blue: 120/255)
var darkGrayBackgroundColor: Color = Color(red: 58/255, green: 58/255, blue: 60/255)
var countriesColor: Color = Color(red: 74/255, green: 131/255, blue: 126/255)
var quordleColor: Color = Color(red: 191/255, green: 90/255, blue: 242/255)

var fourGradient: LinearGradient = LinearGradient(gradient: Gradient(colors: [Color(.systemYellow), Color(.systemYellow).opacity(0.7)]), startPoint: .bottom, endPoint: .top)
var fiveGradient: LinearGradient = LinearGradient(gradient: Gradient(colors: [mainColor, mainColor.opacity(0.7)]), startPoint: .bottom, endPoint: .top)
var sixGradient: LinearGradient = LinearGradient(gradient: Gradient(colors: [Color(.systemRed), Color(.systemRed).opacity(0.7)]), startPoint: .bottom, endPoint: .top)
var countriesGradient: LinearGradient = LinearGradient(gradient: Gradient(colors: [countriesColor, countriesColor.opacity(0.7)]), startPoint: .bottom, endPoint: .top)
var quordleGradient: LinearGradient = LinearGradient(gradient: Gradient(colors: [quordleColor, quordleColor.opacity(0.7)]), startPoint: .bottom, endPoint: .top)
