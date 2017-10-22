//
//  LayoutProtocol.swift
//  Pods
//
//  Created by 堀田 有哉 on 2017/08/24.
//
//

import UIKit

public class Layout {
    enum Arrangement {
        case up
        case down
        case left
        case right
        case stay
    }
    
    public var direction: LayoutDirection = .horizontal
    public var itemSize: CGSize = .zero
    public var lineSpacing: CGFloat = 8
    public var transform: TransformProtocol?
    public var path: PathProtocol = DefaultPath()
    
    public init() {}
    
    fileprivate var lastOffset: CGFloat = 0
    fileprivate var scrollDirection: ScrollDirection = .default
    fileprivate var screenOutDirection: ScreenOutDirection = .inside
}

extension Layout {
    func scrollPath(inVisibleRect visibleRect: CGRect, viewFrame: CGRect) -> CGPoint {
        let normalizedCenterX = (viewFrame.origin.x + viewFrame.width / 2 - visibleRect.origin.x - visibleRect.width / 2) / (visibleRect.width / 2)
        let normalizedCenterY = (viewFrame.origin.y + viewFrame.height / 2 - visibleRect.origin.y - visibleRect.height / 2) / (visibleRect.height / 2)
        
        switch direction {
        case .horizontal:
            let y = (1 + path.normalizedPath(withCoordinate: normalizedCenterX)) * visibleRect.height / 2
            return .init(x: viewFrame.origin.x + viewFrame.width / 2, y: y)
            
        case .vertical:
            let x = (1 + path.normalizedPath(withCoordinate: normalizedCenterY)) * visibleRect.width / 2
            return .init(x: x, y: viewFrame.origin.y + viewFrame.height / 2)
        }
    }
    
    func transformWithScroll(inVisibleRect visibleRect: CGRect, viewFrame: CGRect) -> CATransform3D {
        guard let transform = self.transform else { return CATransform3DIdentity }
        
        switch direction {
        case .horizontal:
            let rate = (viewFrame.origin.x + viewFrame.width / 2 - visibleRect.origin.x - visibleRect.width / 2) / (visibleRect.width / 2)
            return transform.transform(withScrollingRate: rate)
            
        case .vertical:
            let rate = (viewFrame.origin.y + viewFrame.height / 2 - visibleRect.origin.y - visibleRect.height / 2) / (visibleRect.height / 2)
            return transform.transform(withScrollingRate: rate)
        }
    }
}

extension Layout {
    var arrangement: Arrangement {
        switch (scrollDirection, screenOutDirection) {
        case (.right, .left):
            return .right
            
        case (.left, .right):
            return .left
            
        case (.up, .down):
            return .up
            
        case (.down, .up):
            return .down
            
        default:
            return .stay
        }
    }
    
    func update(visibleRect: CGRect, rect: CGRect) {
        switch direction {
        case .horizontal where visibleRect.origin.x - lastOffset > 0:
            scrollDirection = .right
            lastOffset = visibleRect.origin.x
            
        case .horizontal where visibleRect.origin.x - lastOffset < 0:
            scrollDirection = .left
            lastOffset = visibleRect.origin.x
            
        case .vertical where visibleRect.origin.y - lastOffset < 0:
            scrollDirection = .up
            lastOffset = visibleRect.origin.y
            
        case .vertical where visibleRect.origin.y - lastOffset > 0:
            scrollDirection = .down
            lastOffset = visibleRect.origin.y
            
        default:
            break
        }
        
        switch direction {
        case .horizontal where !visibleRect.intersects(rect) && rect.origin.x + rect.width < visibleRect.origin.x:
            screenOutDirection = .left
            
        case .horizontal where !visibleRect.intersects(rect) && visibleRect.origin.x + visibleRect.width < rect.origin.x:
            screenOutDirection = .right
            
        case .vertical where !visibleRect.intersects(rect) && rect.origin.y + rect.height < visibleRect.origin.y:
            screenOutDirection = .up
            
        case .vertical where !visibleRect.intersects(rect) && visibleRect.origin.y + visibleRect.height < rect.origin.y:
            screenOutDirection = .down
            
        default:
            screenOutDirection = .inside
        }
    }
}
