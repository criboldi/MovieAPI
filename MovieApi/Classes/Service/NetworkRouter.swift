//
//  NetworkRouter.swift
//  FBSnapshotTestCase
//
//  Created by Christian Riboldi on 9/28/18.
//

import Foundation

public typealias NetworkCompletion = (_ data: Data?, _ error: String?) -> ()
public typealias NetworkRouterCompletion = (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> ()

protocol NetworkRouter: class {
    associatedtype EndPoint: EndPointType
    func request(_ route: EndPoint, completion: @escaping NetworkRouterCompletion)
    func cancel()
}
