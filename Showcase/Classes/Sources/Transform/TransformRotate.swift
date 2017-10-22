//
//  TransformRotate.swift
//  Pods-DisplayCollectionViewDemo
//
//  Created by Yuya Horita on 2017/10/11.
//

import Foundation

public class TransformRotate: TransformProtocol {
    public var startRate: CGFloat = 0.2
    public var rotateAngle: CGFloat = 2 * .pi
    
    public func transform(withScrollingRate rate: CGFloat) -> CATransform3D {
        let canRotate = abs(rate) > startRate
        let optimizedRate = (rate + (rate < 0 ? startRate : -startRate))
        
        return CATransform3DMakeRotation(canRotate ? rotateAngle * optimizedRate : 0, 0, 0, 1)
    }
    
    public init() {}
}
