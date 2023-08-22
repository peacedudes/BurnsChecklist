//
//  HistoricalPlot.swift
//  BurnsChecklist
//
//  Created by robert on 8/21/23.
//

import Charts
import SwiftUI

struct HistoricalPlot: View {
    let points: [Score]

    var body: some View {
        let plotColor = Color(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1))
        let curGradient = LinearGradient(
            gradient: Gradient (
                colors: [
                    plotColor.opacity(0.5),
                    plotColor.opacity(0.2),
                    plotColor.opacity(0.05),
                ]
            ),
            startPoint: .top,
            endPoint: .bottom)
  
        VStack {
            GroupBox ( "Depression History") {
                Chart {
                    ForEach(points) { score in
                        LineMark(
                            x: .value("Day", score.date/*, unit: .day*/),
                            y: .value("Score", score.value)
                        )
                        .interpolationMethod(.catmullRom)
                        .foregroundStyle(plotColor)
                        
                        AreaMark(
                            x: .value("Day", score.date/*, unit: .day*/),
                            y: .value("Score", score.value)
                        )
                        .interpolationMethod(.catmullRom)
                        .foregroundStyle(curGradient)
                        .lineStyle(StrokeStyle(lineWidth: 3))
                        .accessibilityLabel(score.dayString)
                        .accessibilityValue("Stress score \(score.value)")
                    }
                }
                .chartYAxis {
                    AxisMarks(values: [0, 6, 11, 26, 51, 76]) {
                        let value = $0.as (Int.self)!
                        AxisValueLabel {
                            Text(value.depressionLabel).foregroundColor(value.depressionColor)
                        }
                        AxisGridLine()
                    }
                }
                .background(Color(hue: 0.10, saturation: 0.10, brightness: 0.98))
                .cornerRadius(20)
            }
        }
    }
}

#Preview {
    HistoricalPlot(points: Score.sampleData)
        .frame(height: 300)
        .padding()
}

extension Int {
    var depressionColor: Color {
        self <= 5 ? Color(#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)) :
        self <= 10 ? Color(#colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)) :
        self <= 25 ? Color(#colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1)) :
        self <= 50 ? Color(#colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)) :
        self <= 75 ? Color(#colorLiteral(red: 1, green: 0.1857388616, blue: 0.5733950138, alpha: 1)) : Color(#colorLiteral(red: 1, green: 0.1857388616, blue: 0.5733950138, alpha: 1))
    }
}

extension Int {
    var depressionLabel: String {
        self <= 5 ? "none" :
        self <= 10 ? "unhappy" :
        self <= 25 ? "mild" :
        self <= 50 ? "moderate" :
        self <= 75 ? "severe" : "Extreme"
    }
}
