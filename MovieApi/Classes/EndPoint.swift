//
//  EndPoint.swift
//  FBSnapshotTestCase
//
//  Created by Christian Riboldi on 9/28/18.
//

import Foundation

enum NetworkEnvironment {
    case qa
    case production
    case staging
}

public enum MovieAPI {
    case search(title: String)
    case getMovie(byID: String)
    
    struct Constants {
        static let sharedUrlParamaters = ["apikey":NetworkManager.MovieAPIKey,
                                          "r":"xml"]
    }
}

extension MovieAPI: EndPointType {
    
    
    
    var environmentBaseURL: String {
        switch NetworkManager.environment {
            case .production:
                return "http://www.omdbapi.com/"
            case .qa:
                return "http://www.qa.omdbapi.com/"
            case .staging:
                return "http://www.staging.omdbapi.com/"
        }
    }
    
    var baseURL: URL {
        guard let url = URL(string: environmentBaseURL) else {
            fatalError("baseURL could not be configured.")
        }
        return url
    }
    
    var path: String {
//   If there are different paths depending on the endpoint I add the path components here
//        switch self {
//            case .search(let title):
//              return ""
//            case .getMovie(let id):
//              return ""
//        }
        return ""
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var task: HTTPTask {
        switch self {
            case .search(let title):
                let urlParameters = ["s":title] + Constants.sharedUrlParamaters
                return .requestParameters(bodyParameters: nil,
                                          urlParameters: urlParameters)
            case .getMovie(let id):
                let urlParameters = ["i":id] + Constants.sharedUrlParamaters
                return .requestParameters(bodyParameters: nil,
                                          urlParameters: urlParameters)
            default:
                return .request
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
    
}
