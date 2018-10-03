//
//  EndPointType.swift
//  FBSnapshotTestCase
//
//  Created by Christian Riboldi on 9/28/18.
//

import Foundation

protocol EndPointType {
    var baseURL: URL { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var task: HTTPTask { get }
    var headers: HTTPHeaders? { get }
}
