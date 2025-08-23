//
//  CGFloat-Clamped.swift
//  PhotoFinish
//
//  Created by Michael Jones on 23/08/2025.
//

import Foundation

extension CGFloat {
    /// <#Description#>
    /// - Parameter range: <#range description#>
    /// - Returns: <#description#>
    func clamped(in range: ClosedRange<CGFloat>) -> CGFloat {
        Swift.max(range.lowerBound, Swift.min(self, range.upperBound))
    }
}
