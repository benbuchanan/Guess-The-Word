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
    var scale: Double = 1
    var flipped: Bool = false
    var invalid: Bool = false
    var submittedIncorrectly: Int = 0
}

struct AppFont {
    static func regularFont(fontSize: CGFloat) -> Font {
        return Font.custom("MontserratAlternates-Regular", size: fontSize)
    }
    
    static func mediumFont(fontSize: CGFloat) -> Font {
        return Font.custom("MontserratAlternates-Medium", size: fontSize)
    }
    
    static func boldFont(fontSize: CGFloat) -> Font {
        return Font.custom("MontserratAlternates-Bold", size: fontSize)
    }
}

enum Status: String {
    case normal = "normal"
    case correct = "correct"
    case incorrectPlacement = "incorrect_placement"
    case incorrect = "incorrect"
}

// Country
struct Country: Identifiable, Decodable {
    var id: String { countryCode }
    var country: String
    var countryCode: String
    var countryCode3: String
    var numericCode: Int
    var latitude: Double
    var longitude: Double
}

struct Shake: GeometryEffect {
    var amount: CGFloat = 10
    var shakesPerUnit = 3
    var animatableData: CGFloat

    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX:
            amount * sin(animatableData * .pi * CGFloat(shakesPerUnit)),
            y: 0))
    }
}

var countries: [Country] = load("countrydata.json")

func load<T: Decodable>(_ filename: String) -> T {
    let data: Data

    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
        else {
            fatalError("Couldn't find \(filename) in main bundle.")
    }

    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }

    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}
