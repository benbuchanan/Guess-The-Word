//
//  StatsChartView.swift
//  Word Guess
//
//  Created by Ben Buchanan on 2/12/22.
//

import SwiftUI

struct StatsChartView: View {
    @State var scoreArray: [Int]
    @Binding var currentGuess: Int
    @Binding var highlightDistributionBar: Bool
    
    var body: some View {
        VStack {
            Text("Distribution").font(AppFont.regularFont(fontSize: 15))
            ForEach(0..<self.scoreArray.count, id: \.self) { i in
                HStack {
                    Text("\(i + 1)").frame(minWidth: 10)
                    BarChartCell(value: self.scoreArray[i] != 0 && normalizedValue(index: i) < 0.1 ? 0.1 : normalizedValue(index: i), barColor: self.highlightDistributionBar ? i == self.currentGuess ? secondaryColor : mainColor : mainColor, textValue: String(self.scoreArray[i]))
                }
            }
        }
    }
    
    func normalizedValue(index: Int) -> Double {
        guard let max = self.scoreArray.max() else {
            return 1
        }
        if max != 0 {
            return Double(self.scoreArray[index])/Double(max)
        } else {
            return 1
        }
    }
}

struct BarChartCell: View {
                
    var value: Double
    var barColor: Color
    var textValue: String
                         
    var body: some View {
        GeometryReader { metrics in
            ZStack {
                RoundedRectangle(cornerRadius: 5)
                    .fill(barColor)
                    .scaleEffect(CGSize(width: 1, height: 0.85), anchor: .leading)
                HStack {
                    Spacer()
                    if self.textValue != "0" {
                        Text(self.textValue)
                            .padding(.trailing, 10)
                            .foregroundColor(.white)
                    }
                }
//                    .scaleEffect(CGSize(width: value == 0 ? 0.05 : value, height: 0.75), anchor: .leading)
            }
            .frame(width: value == 0 ? 15 : metrics.size.width * value)
        }
    }
}
