//
//  Movie.swift
//  FBSnapshotTestCase
//
//  Created by Christian Riboldi on 9/28/18.
//

import Foundation
import SWXMLHash

struct MovieAPISearchResponse {
    let numberOfResults: String
    let wasSuccessful: Bool
    let movies: [Movie]
}

extension MovieAPISearchResponse: DSDecodable {

    private enum MovieAPIResponseCodingKeys: String, CodingKey {
        case numberOfResults = "totalResults"
        case wasSuccessful = "Response"
        case movies = "Search"
    }
    
    init(from decoder: Decoder) throws {
        let containter = try decoder.container(keyedBy: MovieAPIResponseCodingKeys.self)
        
        wasSuccessful = try (containter.decode(String.self, forKey: .wasSuccessful) == "True" ? true : false )
        numberOfResults = try containter.decode(String.self, forKey: .wasSuccessful)
        movies = try containter.decode([Movie].self, forKey: .movies)
    }
    
    init?(node: XMLIndexer) {
        let rootNode = node["root"]
        guard let numberOfResults = rootNode.element?.attribute(by: "totalResults")?.text,
              let wasSuccessfulText = rootNode.element?.attribute(by: "response")?.text else {
            return nil
        }
        
        self.numberOfResults = numberOfResults
        self.wasSuccessful = wasSuccessfulText == "True" ? true : false
        movies = rootNode.children.compactMap { Movie.init(node: $0) }
    }
    
    public static func deserialize(element: XMLIndexer) throws -> MovieAPISearchResponse {
        guard let movieAPISeachResponse = MovieAPISearchResponse(node: element) else {
            throw XMLDeserializationError.nodeHasNoValue
        }
        return movieAPISeachResponse
    }
    
}

public enum MovieType: String {
    case movie, series, episode, none
    
    public init(rawValue: String) {
        switch rawValue {
            case "movie":
                self = .movie
            case "series":
                self = .series
            case "episode":
                self = .episode
            default:
                self = .none
        }
    }
}

public struct Movie {
    public let title: String
    public let year: String
    public let id: String
    public let type: MovieType
    public let genre: String?
    public let director: String?
    public let actors: String?
    public let plot: String?
}

extension Movie: DSDecodable {

    private enum MovieCodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case id = "imdbID"
        case type = "Type"
        case genre = "Genre"
        case director = "Director"
        case actors = "Actors"
        case plot = "Plot"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: MovieCodingKeys.self)
        
        title = try container.decode(String.self, forKey: .title)
        year = try container.decode(String.self, forKey: .year)
        id = try container.decode(String.self, forKey: .id)
        type = try MovieType(rawValue: container.decode(String.self, forKey: .type))
        
        genre = container.contains(.genre) ? try container.decode(String.self, forKey: .genre) : nil
        director = container.contains(.director) ? try container.decode(String.self, forKey: .director) : nil
        actors = container.contains(.actors) ? try container.decode(String.self, forKey: .actors) : nil
        plot = container.contains(.plot) ? try container.decode(String.self, forKey: .plot) : nil
    }
    
    public init?(node: XMLIndexer) {
        let rootNode = node["root"]["movie"].element != nil ? node["root"]["movie"] : node
        
        guard let title = rootNode.element?.attribute(by: "title")?.text,
              let year = rootNode.element?.attribute(by: "year")?.text,
              let id = rootNode.element?.attribute(by: "imdbID")?.text,
              let movieType = rootNode.element?.attribute(by: "type")?.text else {
            return nil
        }
        
        self.title = title
        self.year = year
        self.id = id
        self.type = MovieType(rawValue: movieType)
        
        genre = rootNode.element?.attribute(by: "genre")?.text ?? nil
        director = rootNode.element?.attribute(by: "director")?.text ?? nil
        actors = rootNode.element?.attribute(by: "actors")?.text ?? nil
        plot = rootNode.element?.attribute(by: "plot")?.text ?? nil
        
    }
    
    public static func deserialize(element: XMLIndexer) throws -> Movie {
        guard let movie = Movie(node: element) else {
            throw XMLDeserializationError.nodeHasNoValue
        }
        return movie
    }
}
