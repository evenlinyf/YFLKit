//
//  YFLObservable.swift
//  YFLKit
//
//  Created by Even Lin on 2022/5/5.
//

import Foundation

class YFLObservable<T> {
   
    typealias Listener = (T?) -> Void
    
    var value: T? {
        didSet {
            listeners.forEach { $0(value) }
        }
    }
    
    private init() {}
    
    init(_ value: T?) {
        self.value = value
    }
    
    private var listeners: [Listener] = []
    
    func bind(_ listener: @escaping Listener) {
        listener(value)
        listeners.append(listener)
    }
}
