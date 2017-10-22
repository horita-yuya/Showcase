//
//  Transform.swift
//  Pods-DisplayCollectionViewDemo
//
//  Created by Yuya Horita on 2017/10/10.
//

import Foundation

public enum NormalizedRangeType {
    case centerPeak
    case centerTrough
    case `default`
}

public protocol TransformProtocol: class {
    func transform(withScrollingRate rate: CGFloat) -> CATransform3D
}

public extension TransformProtocol {
    func transformRange(withType type: NormalizedRangeType, rate: CGFloat) -> CGFloat {
        switch type {
        case .centerPeak:
            return abs(abs(rate) - 1)
            
        case .centerTrough:
            return abs(rate)
            
        case .default:
            return rate
        }
    }
}
