//
//  TransformScale.swift
//  Pods-DisplayCollectionViewDemo
//
//  Created by Yuya Horita on 2017/10/11.
//

import Foundation

public class TransformScale: TransformProtocol {
    public var startRate: CGFloat = 0.8
    public var normalizedMinimumScale: CGFloat = 0.5
    
    public func transform(withScrollingRate rate: CGFloat) -> CATransform3D {
        let transformedRate = transformRange(withType: .centerPeak, rate: rate)
        let canScale = transformedRate < startRate
        let optimizedRate = max(transformedRate + (1 - startRate), normalizedMinimumScale)
        
        return CATransform3DMakeScale(canScale ? optimizedRate : 1, canScale ? optimizedRate : 1, 0)
    }
    
    public init() {}
}
