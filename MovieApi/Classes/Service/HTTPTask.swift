//
//  HTTPTask.swift
//  FBSnapshotTestCase
//
//  Created by Christian Riboldi on 9/28/18.
//

import Foundation

public typealias HTTPHeaders = [String:String]

// This is where I will need to add an encoder enum to each request so that each one takes either an XMLEncoder or a JSONEncoer and then
// in the configure parameters function I will have to add a switch which will encode the request body paramaters with the corresponding encoder.
public enum HTTPTask {
    case request
    
    case requestParameters(bodyParameters: Parameters?, urlParameters: Parameters?)
    
    case requestParametersAndHeaders(bodyParameters: Parameters?,
                                     urlParameters: Parameters?,
                                     additionHeaders: HTTPHeaders?)
    
    // There may be additional cases such as download, upload...etc
}
