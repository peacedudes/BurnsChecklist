//
//  Score.swift
//  BurnsChecklist
//
//  Created by robert on 8/21/23.
//

import Foundation

struct Score: Codable {
    let dateString: String
    let score: Int
    let suicidal: Int

    var date: Date { Self.dateFormatter.date(from: self.dateString) ?? Date.distantPast }

    static var dateFormatter: DateFormatter {
        let format = DateFormatter()
        format.dateFormat = "yyyyMMdd"
        return format
    }
    
    init(date: Date? = nil, _ score: Int, _ suicidalScore: Int) {
        self.dateString = Self.dateFormatter.string(from: date ?? Date())
        self.score = score
        // TODO: nothing is done with this, but it would be nice to notice it changing and offer specific encouragements.
        // TODO: Should we be saving the entire survey, and offering specific encouragement for sections that change?
        self.suicidal = suicidalScore
    }
}

extension Score: Identifiable, Equatable {
    var id: String { dateString }
}

extension Score {
    fileprivate init(day: String, _ score: Int, _ suicidalScore: Int) {
        self.dateString = day
        self.score = score
        self.suicidal = suicidalScore
    }
    static var sampleData: [Score] {[
        Score(day: "20230710", 65, 0),
        Score(day: "20230711", 73, 0),
        Score(day: "20230712", 82, 0),
        Score(day: "20230713", 55, 0),
        Score(day: "20230714", 66, 0),
        Score(day: "20230715", 26, 0),
        Score(day: "20230716", 22, 0)]
    }
}

extension Array where Element == Score {
    func index(of score: Score) -> Int? {
        self.indices.first(where: { self[$0].dateString == score.dateString })
    }
    mutating func update(_ new: Score) {
        if let replacement = self.index(of: new ) {
            self[replacement] = new
        } else {
            self.append(new)
            self.sort {$0.dateString < $1.dateString}
        }
    }
}

extension Encodable {
    // These were modified from suggestion on https://stackoverflow.com/questions/33186051/swift-convert-struct-to-json
    // TODO: make better names, and review API
    ///  convert Codable thing to json String
    var asJSON: String {
        let jsonData = try! JSONEncoder().encode(self)
        return String(data: jsonData, encoding: .utf8)!
    }
}

extension String {
    /// convert String from json to Decodable thing
    func fromJSON<T: Decodable>() -> T? {
        return try? JSONDecoder().decode(T.self, from: self.data(using: .utf8)!)
    }
}
