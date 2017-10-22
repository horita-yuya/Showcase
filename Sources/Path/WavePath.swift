//
//  WavePath.swift
//  Pods-DisplayCollectionViewDemo
//
//  Created by 堀田 有哉 on 2017/09/20.
//

import Foundation

public final class WavePath: PathProtocol {
    public var normalizedAmplitude: CGFloat = 0.5
    public var normalizedOffset: CGFloat = 0
    public var offsetAngle: CGFloat = 0
    public var angle: CGFloat = .pi / 2
    
    public func normalizedPath(withCoordinate value: CGFloat) -> CGFloat {
        let theta = value * angle
        return normalizedAmplitude * sin(theta - offsetAngle) + normalizedOffset
    }
    
    public init() {}
}
