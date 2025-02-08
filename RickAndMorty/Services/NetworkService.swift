//
//  NetworkService.swift
//  RickAndMorty
//
//  Created by Anton Stogov on 02/02/2025.
//

import Foundation

// MARK: - NetworkService

class NetworkService {
    static let shared = NetworkService()
    
    // MARK: - Public Methods
    
    /// Получаем список персонажей с API.
    func getCharacters(completion: @escaping ([Character]) -> Void) {
        guard let url = URL(string: "https://rickandmortyapi.com/api/character") else { return }
        
        // MARK: - Сетевой запрос, валидация и декодирование JSON
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard let data = data, error == nil else { return }
            do {
                let response = try JSONDecoder().decode(CharacterResponse.self, from: data)
                completion(response.results)
            } catch {
                print(error)
            }
        }
        task.resume()
    }
}

// MARK: - Модели

struct CharacterResponse: Decodable {
    let results: [Character]
}
