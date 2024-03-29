//
//  YFLAPI.swift
//  YFLKit
//
//  Created by Even Lin on 2022/5/5.
//

import Foundation

public enum APIMethod {
    case get, post, upload
}

public protocol APIProtocol {
    var path: String { get }
    var baseUrl: URL { get }
    var middlePath: String { get }
    var method: APIMethod { get }
    var headers: [String: String]? { get }
    func parameters() -> [String: Any]?
}

