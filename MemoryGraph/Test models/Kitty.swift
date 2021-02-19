//
//  Kitty.swift
//  MemoryGraph
//
//  Created by David Grigoryan on 13.10.2020.
//  Copyright © 2020 David Grigoryan. All rights reserved.
//

import Foundation

@objc public class Kitty: NSObject, Animal {
    public var name: String {
        return "Tom"
    }
    private var container: SwiftContainer?
    
    init(container: SwiftContainer) {
        self.container = container
    }
    
    override init() {
        
    }
}
