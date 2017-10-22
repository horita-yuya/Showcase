//
//  CGPointExt.swift
//  Pods
//
//  Created by Yuya Horita on 2017/09/02.
//
//

import Foundation

extension CGPoint {
    static func +(left: CGPoint, right: CGPoint) -> CGPoint {
        return .init(x: left.x + right.x, y: left.y + right.y)
    }
    
    static func +=(left: inout CGPoint, right: CGPoint) {
        left = left + right
    }
    
    static func -(left: CGPoint, right: CGPoint) -> CGPoint {
        return .init(x: left.x - right.x, y: left.y - right.y)
    }
    
    static func -=(left: inout CGPoint, right: CGPoint) {
        left = left - right
    }
}
