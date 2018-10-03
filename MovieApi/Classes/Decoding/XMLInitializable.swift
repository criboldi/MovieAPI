//
//  XMLInitializable.swift
//  MovieApi
//
//  Created by Christian Riboldi on 10/2/18.
//

import Foundation
import SWXMLHash

public protocol XMLInitializable: XMLIndexerDeserializable {
    init?(node: XMLIndexer)
    static func deserialize(element: XMLIndexer) throws -> Self
}
