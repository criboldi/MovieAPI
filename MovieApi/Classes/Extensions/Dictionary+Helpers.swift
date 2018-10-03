//
//  Dictionary+Helpers.swift
//  MovieApi
//
//  Created by Christian Riboldi on 10/3/18.
//

import Foundation

public extension Dictionary {
    
    public static func + (lhs: [Key: Value], rhs: [Key: Value]) -> [Key: Value] {
        var result = lhs
        rhs.forEach { result[$0] = $1 }
        return result
    }
    
    public static func += (lhs: inout [Key: Value], rhs: [Key: Value]) {
        rhs.forEach { lhs[$0] = $1 }
    }
}
