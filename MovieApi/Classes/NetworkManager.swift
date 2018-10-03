//
//  NetworkManager.swift
//  FBSnapshotTestCase
//
//  Created by Christian Riboldi on 9/28/18.
//

import Foundation

public struct NetworkManager {
    static let environment: NetworkEnvironment = .production
    static let MovieAPIKey = "b97e363a"
    private let router: Router<MovieAPI>
    private let decoder: DataDecoder
    
    public init(_ decoderType: DecoderType) {
        switch decoderType {
        case .json:
            decoder = JSONDataDecoder()
            router = Router<MovieAPI>(bodyEncoder: JSONParameterEncoder())
        case .xml:
            decoder = XMLDataDecoder()
            router = Router<MovieAPI>(bodyEncoder: JSONParameterEncoder()) // Replace with XMLEncoder
        }
    }
    
    enum NetworkResponse: String {
        case success
        case authenticationError = "You need to be authenticated first."
        case badRequest = "Bad request."
        case badNetwork = "Please check your network connection."
        case outdated = "The url you requested is outdated."
        case failed = "Network request failed."
        case noData = "Response had no data to decode."
        case unableToDecode = "We could not decode the response."
    }
    
    enum Result<String> {
        case success
        case failure(String)
    }
    
    public func searchForMovie(withTitle title: String, completion: @escaping (_ movie: [Movie]?, _ error: String?) -> ()) {
        router.request(.search(title: title)) { (data, response, error) in
            self.handleResponse(data, response, error, MovieAPISearchResponse.self, { (movieResponse, error) in
                completion(movieResponse?.movies, error)
            })
        }
    }
    
    public func getMovie(byId id: String, completion: @escaping (_ movie: Movie?, _ error: String?) -> ()) {
        router.request(.getMovie(byID: id)) { (data, response, error) in
            self.handleResponse(data, response, error, Movie.self, { (movie, error) in
                completion(movie, error)
            })
        }
    }
    
    
    fileprivate func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String> {
        switch response.statusCode {
        case 200...299: return .success
        case 401...500: return .failure(NetworkResponse.authenticationError.rawValue)
        case 501...599: return .failure(NetworkResponse.badRequest.rawValue)
        case 600: return .failure(NetworkResponse.outdated.rawValue)
        default: return .failure(NetworkResponse.failed.rawValue)
        }
    }
    
    fileprivate func handleResponse<T: DSDecodable> (_ data: Data?, _ response: URLResponse?, _ error: Error?, _ decodingType: T.Type, _ completion: (_ responseData: T?, _ error: String?) -> ()) {
        
        if error != nil {
            completion(nil, NetworkResponse.badRequest.rawValue)
        }
        
        if let response = response as? HTTPURLResponse {
            let result = self.handleNetworkResponse(response)
            switch result {
            case .success:
                do {
                    let responseData = try decoder.decode(data: data, intoType: decodingType)
                    completion(responseData, nil)
                } catch {
                    completion(nil, NetworkResponse.unableToDecode.rawValue)
                }
            case .failure(let networkFailureError):
                completion(nil, networkFailureError)
            }
        }
        
    }
    
}
