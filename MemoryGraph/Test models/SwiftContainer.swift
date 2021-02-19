//
//  SwiftContainer.swift
//  MemoryGraph
//
//  Created by David Grigoryan on 13.10.2020.
//  Copyright © 2020 David Grigoryan. All rights reserved.
//

import Foundation

@objcMembers
public final class SwiftContainer: NSObject {
    public let animals: [Animal] = [Dog(), Kitty()]
    private var pKitty: Kitty?
    
    public override init() {
        super.init()
        pKitty = Kitty(container: self)
    }
}
