//
//  BurnsChecklistView.swift
//  BurnsChecklist
//
//  Created by robert on 8/21/23.
//

import SwiftUI

struct BurnsChecklistView: View {
    @State private var answers: [Int] = Array(repeating: 0, count: 26)
    private var score: Int { answers.reduce(0, +) }
    @AppStorage("savedScores") var savedScores = ""
    @State private var scoreHistory = [Score]()

#if os(OSX)
    typealias Container = ScrollView
#else
    typealias Container = Form
#endif
    
    let ratings: [(value: Int, name: String)] = [
        (0, "Not at all"),
        (1, "Somewhat"),
        (2, "Moderately"),
        (3, "A Lot"),
        (4, "Extremely"),
    ]
    var body: some View {
        VStack {
            Text("Burn's Depression Checklist").font(.title3)
            Text("Rate how much you have experienced each symptom during the past week, including today.").padding(8)
            HStack {
                ForEach(ratings, id: \.value) { rating in
                    Text(("\(rating.value):\n\(rating.name)"))
                        .font(.caption)
                        .multilineTextAlignment(.center)
                }
            }
    
            Container {
                ForEach(symptoms, id: \.0) { (title, questions) in
                    HStack {
                        Text(title).font(.title3)
                            .foregroundColor(.blue)
                        Spacer()
                    }
                    .padding(.top)
                    
                    ForEach(questions, id: \.self.number) { (number, question) in
                        VStack {
                            HStack {
                                Text("\(number). \(question)")
                                Spacer(minLength: 0)
                            }
                            HStack {
                                Spacer()
                                Picker("", selection: $answers[number - 1]) {
                                    ForEach(ratings, id: \.value) { rating in
                                        Text(" \(rating.value) ")
                                            .tag(rating.value)
                                    }
                                }
                                .pickerStyle(SegmentedPickerStyle())
                                .frame(maxWidth: 400)
                            }
                        }
                        .padding(.top)
                    }
                }
#if os(OSX)
                .padding(.horizontal, 44)
#endif
                HStack {
                    Text("Score: \(score) points")
                    Text(score.depressionIcon).font(.largeTitle)
                }
                .padding([.top, .leading, .trailing], 50)
                
                VStack {
                    ForEach(levelOfDepression, id: \.min) { depression in
                        HStack {
                            Text(depression.description)
                            Spacer()
                            Text("\(depression.min) - \(depression.max)")
                        }
                        .background(score.depressionColor
                            .opacity(depression.min ... depression.max ~= score ? 0.3 : 0))
                    }
                }
                .frame(width: 250, height: 6 * 25)
                .padding(.horizontal, 44)
                
                VStack {
                    if scoreHistory.count > 2 {
                        HistoricalPlot(points: scoreHistory + [Score(score)])
                            .padding()
                            .frame(height: 300)
                    }
                    Text("Would you like to save today's self-evaluation of \(score)?")
                        .padding(.top)
                    Button("Save") {
                        scoreHistory.append(Score(score))
                        savedScores = scoreHistory.asJSON
                    }
                    .padding()
                }
                Spacer()
            
                if score >= 60 {
                    let colors = [Color(#colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)), Color(#colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)), Color(#colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)), Color(#colorLiteral(red: 0.5058823824, green: 0.3372549117, blue: 0.06666667014, alpha: 1))]
                    Text(encouragements.randomElement()!)
                        .multilineTextAlignment(.center)
                        .foregroundColor(colors.randomElement())
                        .padding()
                }
#if os(iOS)
                if score > 75 && answers[23...25].reduce(0, +) > 7 {
                    VStack(alignment: .center) {
                        Text("Your story isn't over.  Help is available.")
                        Text("National Suicide Prevention Lifeline")
                        //  Clickable telphone number
                        Link("(800) 273-8255", destination: URL(string: "tel:8002738255")!)
                    }
                }
#endif
            }
        }
        .onAppear {
            scoreHistory = savedScores.fromJSON() ?? []
        }
    }
}

extension Int {

    var depressionIcon: String {
        for level in levelOfDepression {
            let range = level.min ... level.max
            if range.contains(self) {
                return level.icon
            }
        }
        return ""
    }
}

#Preview {
    BurnsChecklistView()
}
