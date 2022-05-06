//
//  YFLObservable.swift
//  YFLKit
//
//  Created by Even Lin on 2022/5/5.
//

import Foundation

public class YFLObservable<T> {
   
    public typealias Listener = (T?) -> Void
    
    public var value: T? {
        didSet {
            listeners.forEach { $0(value) }
        }
    }
    
    private init() {}
    
    public init(_ value: T?) {
        self.value = value
    }
    
    private var listeners: [Listener] = []
    
    public func bind(_ listener: @escaping Listener) {
        listener(value)
        listeners.append(listener)
    }
}
