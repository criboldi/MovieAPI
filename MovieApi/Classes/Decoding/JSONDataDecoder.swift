//
//  JSONDataDecoder.swift
//  FBSnapshotTestCase
//
//  Created by Christian Riboldi on 10/2/18.
//

import Foundation

public struct JSONDataDecoder: DataDecoder {
    public func decode<T: DSDecodable>(data: Data?, intoType type: T.Type) throws -> T? {
        guard let responseData = data else {
            return nil
        }
        do {
            let decodedData = try JSONDecoder().decode(type, from: responseData)
            return decodedData
        }
    }
    
}
