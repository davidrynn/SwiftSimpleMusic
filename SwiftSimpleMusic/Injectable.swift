//
//  Injectable.swift
//  SwiftSimpleMusic
//
//  Created by David Rynn on 9/10/16.
//  Copyright © 2016 David Rynn. All rights reserved.
//

import Foundation

protocol Injectable {
    associatedtype Item
    func inject(item: Item)
    func assertDependencies()
}

//thanks to Natasha The Robot