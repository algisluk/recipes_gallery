//
//  GalleryService.swift
//  gallery
//
//  Created by Algis on 17/10/2020.
//

import Foundation

public enum APIServiceError: Error {
    case apiError
    case invalidEndpoint
    case invalidResponse
    case noData
    case decodeError
}

protocol GalleryServiceProtocol {
    func fetchImages(completion: @escaping (Result<[Recipe], APIServiceError>) -> Void)
}


class GalleryService: GalleryServiceProtocol {
    
    private let baseURL = "http://www.recipepuppy.com/api/?i=onions,garlic&q=omelet"
    
    public func fetchImages(completion: @escaping (Result<[Recipe], APIServiceError>) -> Void)  {
        
        guard let url = URL(string: baseURL) else {
            completion(.failure(.invalidEndpoint))
            return
        }
        
        URLSession.shared.dataTask(with: url) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let (response, data)):
                    guard let statusCode = (response as? HTTPURLResponse)?.statusCode, 200..<299 ~= statusCode else {
                        completion(.failure(.invalidResponse))
                        return
                    }
                    do {
                        let values: RecipeResponse = try JSONDecoder().decode(RecipeResponse.self, from: data)
                        completion(.success(values.all))
                    } catch {
                        completion(.failure(.decodeError))
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    completion(.failure(.apiError))
                }
            }
        }.resume()
    }
}
