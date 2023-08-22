//
//  Score.swift
//  BurnsChecklist
//
//  Created by robert on 8/21/23.
//

import Foundation

struct Score: Codable {
    let date: Date
    let value: Int

    init(date: Date? = nil, _ value: Int) {
        self.date = date ?? Date()
        self.value = value
    }
}

extension Score: Identifiable {
    var id: Date { date }
}

extension Score {
    var dayString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}

extension Score {
    fileprivate init(day: String, value: Int) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        self.date = formatter.date(from: day) ?? Date.distantPast
        self.value = value
    }
    static var sampleData: [Score] {
        [
            Score(day: "20230710", value: 65),
            Score(day: "20230711", value: 73),
            Score(day: "20230712", value: 82),
            Score(day: "20230713", value: 55),
            Score(day: "20230714", value: 66),
            Score(day: "20230715", value: 26),
            Score(day: "20230716", value: 22)
        ]
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
