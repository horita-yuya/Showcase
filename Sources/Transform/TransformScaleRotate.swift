//
//  TransformScaleRotate.swift
//  Pods-DisplayCollectionViewDemo
//
//  Created by Yuya Horita on 2017/10/11.
//

import Foundation

public class TransformScaleRotate: TransformProtocol {
    public var transformRotate: TransformRotate = .init()
    public var transformScale: TransformScale = .init()
    
    public func transform(withScrollingRate rate: CGFloat) -> CATransform3D {
        return CATransform3DConcat(transformRotate.transform(withScrollingRate: rate), transformScale.transform(withScrollingRate: rate))
    }
    
    public init() {}
}
