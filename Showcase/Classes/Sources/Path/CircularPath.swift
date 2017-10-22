//
//  CircularPath.swift
//  Pods-DisplayCollectionViewDemo
//
//  Created by 堀田 有哉 on 2017/09/19.
//

import Foundation

public final class CircularPath: PathProtocol {
    public var normalizedRadius: CGFloat = 1
    public var normalizedOffset: CGFloat = -1
    public var offsetAngle: CGFloat = 0
    public var angle: CGFloat = .pi / 2
    
    public func normalizedPath(withCoordinate value: CGFloat) -> CGFloat {
        let theta = value * angle
        return normalizedRadius * cos(theta - offsetAngle) + normalizedOffset
    }
    
    public init() {}
}
