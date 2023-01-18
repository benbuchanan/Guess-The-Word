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
    var viewWidth: Double
    
    var body: some View {
        VStack {
            ForEach(0..<self.scoreArray.count, id: \.self) { i in
                HStack {
                    Text("\(i + 1)")
                        .font(.headline)
                        .frame(minWidth: 10)
                        .padding(.horizontal, 5)
                    BarChartCell(value: self.scoreArray[i] != 0 && normalizedValue(index: i) < 0.1 ? 0.1 : normalizedValue(index: i), barColor: self.highlightDistributionBar ? i == self.currentGuess ? mainColor : secondaryColor : secondaryColor, textValue: String(self.scoreArray[i]))
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
            VStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 25)
                        .fill(barColor)
                        .frame(minHeight: 25)
                        .frame(maxHeight: metrics.size.height / 3)
//                        .frame(height: metrics.size.height / 2)
                    HStack {
                        Spacer()
                        if self.textValue != "0" {
                            Text(self.textValue)
                                .padding(.trailing, 10)
                                .foregroundColor(.white)
                        }
                    }
                }
                .frame(width: value == 0 ? 15 : metrics.size.width * value)
            }
            .frame(width: metrics.size.width, height: metrics.size.height, alignment: .leading)
        }
    }
}

struct GameView_Preview2: PreviewProvider {
    static var previews: some View {
        StatsChartView(scoreArray: [0,1,3,2,1,5], currentGuess: .constant(1), highlightDistributionBar: .constant(false), viewWidth: 10)
    }
}
