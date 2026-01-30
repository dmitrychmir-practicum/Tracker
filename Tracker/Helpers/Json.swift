//
//  Json.swift
//  Tracker
//
//  Created by Дмитрий Чмир on 23.01.2026.
//

import Foundation

final class Json {
    static func encode(_ value: Encodable) throws -> Data {
        try JSONEncoder().encode(value)
    }
    
    static func decode<T: Decodable>(_ type: T.Type, from value: Data) throws -> T {
        try JSONDecoder().decode(T.self, from: value)
    }
}
