//
//  Parameters.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 21/11/15.
//  Copyright © 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import SwiftyJSON

/**
*  URLQueryItemStringConvertible convert URLParameter to String
*/
protocol URLQueryItemStringConvertible {
    var stringValue: String { get }
}

// MARK: Parameters

/**
*  Parameters
*
*  HTTP Request parameters. Wrapper for [String: AnyObject] to simplify URL Encoding.
*/
struct Parameters {
    
    // MARK: ParamatersEncoding declaration
    enum ParametersEncoding {
        case URL
        case Body
    }
    
    /// encoding specifies the encoding type, URL or Body encoding
    let encoding: ParametersEncoding
    
    private var underlyingDictionary = [String: AnyObject]()
    
    /**
    Subscript for accessing/setting each parameter for key
    - parameter key: String key for accessing parameter value
    - returns: AnyObject that can be kept in [String: AnyObject]
    */
    subscript(key: String) -> AnyObject? {
        get { return underlyingDictionary[key] }
        set(value) { underlyingDictionary[key] = value }
    }
}

// MARK: - Create query items from given Parameters
extension Parameters {
    var queryItems: [NSURLQueryItem] {
        guard encoding == .URL else { return [] }
        return underlyingDictionary.filter { $1 is URLQueryItemStringConvertible  }.map {
            NSURLQueryItem(name: $0, value: $1.stringValue)
        }
    }
}

// MARK: - URLParameterStringConvertible common extension
extension URLQueryItemStringConvertible {
    var stringValue: String { return String(self) }
}

/**
*  URLParameterStringConvertible basic types conformance
*/

/// Simplifies conversion from Parameters to NSURLQueryItem
extension String: URLQueryItemStringConvertible {
    var stringValue: String { return self }
}

extension UInt: URLQueryItemStringConvertible {}
extension UInt8: URLQueryItemStringConvertible {}
extension UInt16: URLQueryItemStringConvertible {}
extension UInt32: URLQueryItemStringConvertible {}
extension UInt64: URLQueryItemStringConvertible {}

extension Int: URLQueryItemStringConvertible {}
extension Int8: URLQueryItemStringConvertible {}
extension Int16: URLQueryItemStringConvertible {}
extension Int32: URLQueryItemStringConvertible {}
extension Int64: URLQueryItemStringConvertible {}

extension Float: URLQueryItemStringConvertible {}

extension Double: URLQueryItemStringConvertible {}

extension Bool: URLQueryItemStringConvertible {}

extension NSNull: URLQueryItemStringConvertible {
    var stringValue: String { return "null" }
}
