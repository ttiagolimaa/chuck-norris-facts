//
//  jokeModel.swift
//  Chuck Norris
//
//  Created by Tiago Caldeira Ortiz Lima on 11/02/22.
//

import Foundation

struct Joke: Codable {
    let categories: [String]
    let value: String
    let url: String
}


struct SearchJokes: Codable {
    let result: [Joke]
}
