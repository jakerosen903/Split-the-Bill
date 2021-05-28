//
//  Extensions.swift
//  iOSFindMyText
//
//  Created by Emily Mittleman on 4/18/21.
//  Copyright © 2021 Anupam Chugh. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    var cgImageOrientation : CGImagePropertyOrientation
    {
        switch imageOrientation {
        case .up: return .up
        case .upMirrored: return .upMirrored
        case .down: return .down
        case .downMirrored: return .downMirrored
        case .leftMirrored: return .leftMirrored
        case .right: return .right
        case .rightMirrored: return .rightMirrored
        case .left: return .left
        default: return.up
            
        }
    }
}



extension String
{
    func trim() -> String
    {
        return self.trimmingCharacters(in: CharacterSet.whitespaces)
    }
}
