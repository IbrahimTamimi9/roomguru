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
*  HTTP Request parameters. Wrapper for [String: AnyObject] to simplify URL Encoding.
*/
struct Parameters {
    
    // MARK: ParamatersEncoding declaration
    enum Encoding {
        case URL
        case JSON
    }
    
    /// encoding specifies the encoding type, URL or Body encoding
    let encoding: Encoding
    
    private var underlyingDictionary = [String: AnyObject]()
    
    init(encoding: Encoding) {
        self.encoding = encoding
    }
    
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
    
    /// Maps Parameters values conforming to URLQueryItemStringConvertible, to NSURLQueryItem.
    ///
    /// This computed property will return empty array for parameters encoding different then .URL
    ///
    /// If parameter's value is valid JSON object, it will be converted to NSData and then to String with UTF8 encoding,
    /// So you don't need to implement it on your JSON-valid types.
    ///
    /// Otherwise it will fallback to URLQueryItemStringConvertible implementation
    var queryItems: [NSURLQueryItem] {
        guard encoding == .URL else { return [] }
        return underlyingDictionary
            .filter { $1 is URLQueryItemStringConvertible }
            .map { (key, value) in
                NSURLQueryItem(name: key, value: {
                    if NSJSONSerialization.isValidJSONObject(value) {
                        if let data = try? NSJSONSerialization.dataWithJSONObject(value, options: .PrettyPrinted),
                            stringValue = NSString(data: data, encoding: NSUTF8StringEncoding) as? String {
                                return stringValue
                        }
                    }
                    return value.stringValue
                    }())
        }
    }
}

// MARK: - Convert parameters into optional NSData
extension Parameters {
    
    /// Checks if encoding is .JSON and parameters are valid JSON object, then uses NSJSONSerialization
    /// Otherwise returns nil
    var body: NSData? {
        guard encoding == .JSON && NSJSONSerialization.isValidJSONObject(underlyingDictionary) else { return nil }
        return try? NSJSONSerialization.dataWithJSONObject(underlyingDictionary, options: .PrettyPrinted)
    }
}

// MARK: - URLParameterStringConvertible common extension
extension URLQueryItemStringConvertible {
    /// Default implementation - should be handled by String.init
    /// Override for conforming type if String.init doesn't satisfies the requirements
    var stringValue: String { return String(self) }
}

/**
 *  URLParameterStringConvertible basic types conformance
 */
 
 /// Simplifies conversion from Parameters to NSURLQueryItem
extension String: URLQueryItemStringConvertible {
    var stringValue: String { return self }
}

extension NSString: URLQueryItemStringConvertible {
    var stringValue: String { return self as String }
}

extension NSNumber: URLQueryItemStringConvertible {}

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