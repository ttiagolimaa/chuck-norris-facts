//
//  File.swift
//  Chuck Norris
//
//  Created by Tiago Caldeira Ortiz Lima on 11/02/22.
//

import Foundation

class Service {
    
    private var baseUrl = "https://api.chucknorris.io"
    
    func getRandomJoke(callback: @escaping (Result<Joke?, Error>)-> Void){
        let path = "/jokes/random"
        
        guard let url = URL(string: baseUrl + path) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                callback(.failure(error))
            }
            
            guard let data = data else {
                
                return
            }
            
            let joke = try? JSONDecoder().decode(Joke.self, from: data)
            callback(.success(joke))
            
        }
        task.resume()
    }
    
    func searchJoke(query: String, callback: @escaping (Result<SearchJokes?, Error>)-> Void){
        let path = "/jokes/search?query=\(query)"
        
        guard let url = URL(string: baseUrl + path) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                callback(.failure(error))
                return
            }
            guard let data = data else {
                return
            }
            
            let jokes = try? JSONDecoder().decode( SearchJokes.self , from: data)
            callback(.success(jokes))
        }
        
        task.resume()
        
    }
}
