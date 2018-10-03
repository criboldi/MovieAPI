//
//  XMLDataDecoder.swift
//  MovieApi
//
//  Created by Christian Riboldi on 10/2/18.
//

import Foundation
import SWXMLHash

public struct XMLDataDecoder: DataDecoder {
    
    public func decode<T: DSDecodable>(data: Data?, intoType type: T.Type) throws -> T? {
        guard let data = data else { throw DecoderError.invalid }
        let xml = SWXMLHash.parse(data)
        return type.init(node: xml)
    }
}
