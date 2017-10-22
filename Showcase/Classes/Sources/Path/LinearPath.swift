//
//  LinearPath.swift
//  Pods-DisplayCollectionViewDemo
//
//  Created by 堀田 有哉 on 2017/09/20.
//

import Foundation

public final class LinearPath: PathProtocol {
    public var normalizedGradient: CGFloat = -0.5
    public var normalizedInversePosition: CGFloat?
    
    public func normalizedPath(withCoordinate value: CGFloat) -> CGFloat {
        switch normalizedInversePosition {
        case .some(let inverse):
            return value < inverse ? -normalizedGradient * value : normalizedGradient * (value - 2 * inverse)
            
        case .none:
            return normalizedGradient * value
        }
    }
    
    public init() {}
}
