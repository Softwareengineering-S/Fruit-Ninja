//
//  Helper Methods.swift
//  Fruit Ninja
//
//  Created by Christian on 25.10.18.
//  Copyright © 2018 codingenieur. All rights reserved.
//

import Foundation
import UIKit

func randomCGFloat(_ lowerLimit: CGFloat,_ upperLimit: CGFloat) -> CGFloat {
    return lowerLimit + CGFloat(arc4random()) / CGFloat(UInt32.max) * (upperLimit - lowerLimit)
}
