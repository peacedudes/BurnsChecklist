//
//  BurnsChecklistView.swift
//  BurnsChecklist
//
//  Created by robert on 8/21/23.
//

import SwiftUI

struct BurnsChecklistView: View {
    @State private var answers: [Int] = Array(repeating: -1, count: 25)
    private var unanswered: [Int] { answers.indices.filter({ answers[$0] == -1} ) }
    private var score: Int { answers.reduce(0, +) }
    private var suicidalScore: Int { answers[22..<25].reduce(0, +) }
    @AppStorage("savedScores") var savedScores = ""
    @State private var scoreHistory = [Score]()
    @State private var isInfoSheetShowing = false

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
            HStack {
                Spacer()
                Text("Burn's Depression Checklist")
                Spacer()
                Button(action: {
                    isInfoSheetShowing.toggle()
                }) {
                    Label("Info", systemImage: "info.circle.fill")
                        .labelStyle(.iconOnly)
                        .font(.title)
                        .padding()
                }
                .buttonStyle(PlainButtonStyle())
#if os(OSX)
                .focusable(false)
#endif
                .padding(.trailing)
                .sheet(isPresented: $isInfoSheetShowing) {
                    InfoSheetView()
                }
            }
            .font(.title3)
            
            Text("Rate how much you have experienced each symptom during the past week, including today.")
                .foregroundColor(.secondary)
                .padding()
            HStack {
                ForEach(ratings, id: \.value) { rating in
                    Text(("**\(rating.value)**:\n\(rating.name)"))
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
                                    .fixedSize(horizontal: false, vertical: true)
                                Spacer(minLength: 0)
                            }
                            HStack {
                                Spacer()
                                Picker("", selection: $answers[number - 1]) {
                                    let needAnswer = answers[number - 1] == -1 ? "rate:" : "" // "✅"
                                    Text(needAnswer).tag(-1)
                                        .font(.footnote)
                                    ForEach(ratings, id: \.value) { rating in
                                        Text(" \(rating.value) ")
                                            .tag(rating.value)
                                    }
                                }
                                .pickerStyle(SegmentedPickerStyle())
                                .frame(maxWidth: 400, minHeight: 0)
                            }
                        }
                        .padding(.top)
                    }
                }
#if os(OSX)
                .padding(.horizontal, 44)
#endif
                if unanswered.count > 0 {
                    let finished = unanswered.count == 25 ? "started" : "finished"
                    Text("""
                        You're haven't \(finished) yet...
                        there's only \(unanswered.count) more to go.
                         
                        Please go back to rate symptom \(unanswered[0] + 1).
                        """)
                    .multilineTextAlignment(.center)
                    .padding()
                    if scoreHistory.count > 2 {
                        HistoricalPlot(points: scoreHistory)
                            .padding()
                            .frame(height: 300)
                    }
                } else {
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
                    .frame(width: 300, height: 6 * 25)
                    .padding(.horizontal, 44)
                    
                    VStack {
                        let newScore = Score(score, suicidalScore)
                        let scoreIndex = scoreHistory.index(of: newScore)
                        let scoreIsSaved = scoreIndex != nil
                        let isUpdate = scoreIsSaved && scoreHistory[scoreIndex!] != newScore
                            
                        let save = isUpdate ? "Update" : "Save"
                        if scoreHistory.count > 2 {
                            HistoricalPlot(points: scoreHistory)
                                .padding()
                                .frame(height: 300)
                        }
                        if !scoreIsSaved || isUpdate {
                            Text("Would you like to \(save.lowercased()) today's self-evaluation score \(isUpdate ? "to" : "of") \(score)?")
                                .padding(.top)
                            Button(save) {
                                scoreHistory.update(newScore)
                                savedScores = scoreHistory.asJSON
                            }
                            .padding()
                        } else {
                            Text("Your score of \(score) has been saved.")
                        }
                    }
                    Spacer()
                    Feedback(score: score, suicidalScore: suicidalScore)
                }
            }
        }
        .onAppear {
            scoreHistory = savedScores.fromJSON() ?? []
        }
    }
}

struct Feedback: View {
    let score: Int
    let suicidalScore: Int
    
    var body: some View {
        if score >= 60 {
            let colors = [Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)), Color(#colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)), Color(#colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)), Color(#colorLiteral(red: 0.5058823824, green: 0.3372549117, blue: 0.06666667014, alpha: 1))]
            // TODO: some of the longer encouragements seem to get cropped vertically.  WTF?
            Text(encouragements.randomElement()!)
                .multilineTextAlignment(.center)
                .foregroundColor(colors.randomElement())
                .minimumScaleFactor(0.8)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
                .padding()
        }
        if (score > 75 && suicidalScore > 7) || suicidalScore > 9 {
            VStack() {
                Text("""
                Your story isn't over.
                Please know that help is available.
                
                National Suicide Prevention Lifeline
                [(800) 273-8255](tel:800-273-8255")
                """)
                .multilineTextAlignment(.center)
                .lineLimit(nil)
                .padding()
            }
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

struct BurnsCheckListView_Previews: PreviewProvider {
    static var previews: some View {
        BurnsChecklistView()
    }
}
