//
//  GenericCollection+Ext.swift
//  FisherMan
//
//  Created by Yura Granchenko on 27.01.2020.
//  Copyright © 2020 GYS. All rights reserved.
//

import Foundation

extension Array {
    subscript (safe index: Int) -> Element? {
        return (index >= 0 && index < count) ? self[index] : nil
    }
}

extension Array where Element: Equatable {
    
    mutating func remove(_ element: Element) {
        if let index = firstIndex(of: element) {
            self.remove(at: index)
        }
    }
}

extension Collection {
    
    public func all(_ enumerator: (Iterator.Element) -> Void) {
        for element in self {
            enumerator(element)
        }
    }
    
    subscript (includeElement: (Iterator.Element) -> Bool) -> Iterator.Element? {
        for element in self where includeElement(element) == true {
            return element
        }
        return nil
    }
}

extension Dictionary {
    
    public func get<T>(_ key: Key) -> T? {
        return self[key] as? T
    }
}
