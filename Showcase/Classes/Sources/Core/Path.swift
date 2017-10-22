//
//  Path.swift
//  Pods-DisplayCollectionViewDemo
//
//  Created by 堀田 有哉 on 2017/09/19.
//

import Foundation

public protocol PathProtocol {
    func normalizedPath(withCoordinate value: CGFloat) -> CGFloat
}
