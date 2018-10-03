//
//  DataDecoder.swift
//  FBSnapshotTestCase
//
//  Created by Christian Riboldi on 10/2/18.
//

import Foundation
import SWXMLHash

public typealias DSDecodable = Decodable & XMLInitializable

public enum DecoderType {
    case xml, json
}

public protocol DataDecoder {
    func decode<T: DSDecodable>(data: Data?, intoType type: T.Type) throws -> T?
}

internal enum DecoderError: Error {
    case invalid
    case missingAttribute
}
