//
//  Word.swift
//  WordPositive
//
//  Created by Nathaniel Brown on 9/18/21.
//

import Foundation

struct Word: Codable {
  var name: String
  var partOfSpeech: String
  var definition: String
  var examples: [String]?
  var synonyms: [String]?
  var level: Int
  
  static var ExampleWords: [Word] = [
    Word(name: "Unexpected", partOfSpeech: "adjective", definition: "not expected or regarded as likely to happen", examples: ["his death was totally unexpected"], synonyms: ["unforeseen", "unanticipated"], level: 2)
  ]
}


