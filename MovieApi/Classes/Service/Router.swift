//
//  Router.swift
//  FBSnapshotTestCase
//
//  Created by Christian Riboldi on 9/28/18.
//

import Foundation

class Router<EndPoint: EndPointType>: NetworkRouter {
    
    private var task: URLSessionTask?
    private var bodyEncoder: ParameterEncoder
    
    init(bodyEncoder: ParameterEncoder) {
        self.bodyEncoder = bodyEncoder
    }
    
    // TODO: Pass the encoderType here
    func request(_ route: EndPoint, completion: @escaping NetworkRouterCompletion) {
        let session = URLSession.shared
        do {
            // TODO: Pass the encoderType into .buildRequest() here
            let request = try self.buildRequest(from: route)
            task = session.dataTask(with: request, completionHandler: { (data, response, error) in
                completion(data, response, error)
            })
        } catch {
            completion(nil, nil, error)
        }
        self.task?.resume()
    }
    
    func cancel() {
        self.task?.cancel()
    }
    
    // TODO: Pass the encoderType here
    fileprivate func buildRequest(from route: EndPoint) throws -> URLRequest {
        
        var request = URLRequest(url: route.baseURL.appendingPathComponent(route.path),
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: 10.0)
        
        request.httpMethod = route.httpMethod.rawValue
        do {
            switch route.task {
                case .request:
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                case .requestParameters(let bodyParameters, let urlParameters):
                    
                    try self.configureParameters(bodyParameters: bodyParameters,
                                                 urlParameters: urlParameters,
                                                 request: &request)

                case .requestParametersAndHeaders(let bodyParameters, let urlParameters, let additionalHeaders):
                    
                    self.addAdditionalHeaders(additionalHeaders, request: &request)
                    try self.configureParameters(bodyParameters: bodyParameters,
                                                 urlParameters: urlParameters,
                                                 request: &request)
            }
            return request
        } catch {
            throw error
        }
    }
    
    // TODO: Pass the encoderType here
    fileprivate func configureParameters(bodyParameters: Parameters?,
                                         urlParameters: Parameters?,
                                         request: inout URLRequest) throws {
        do {
            // TODO: I will need to add a switch here to check for the type of encoder passed in so that we can tell which encoder to use.
            if let bodyParameters = bodyParameters {
                try bodyEncoder.encode(urlRequest: &request, with: bodyParameters)
            }
            if let urlParameters = urlParameters {
                try URLParameterEncoder().encode(urlRequest: &request, with: urlParameters)
            }
        }
    }
    
    fileprivate func addAdditionalHeaders(_ additionalHeaders: HTTPHeaders?, request: inout URLRequest) {
        guard let headers = additionalHeaders else { return }
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
}
