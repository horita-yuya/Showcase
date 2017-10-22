//
//  ExtendedScrollView.swift
//  Pods
//
//  Created by Yuya Horita on 2017/09/01.
//
//

import UIKit

final class ExtendedScrollView: UIScrollView {
    var topAssist: CGFloat = 0
    var rightAssist: CGFloat = 0
    var bottomAssist: CGFloat = 0
    var leftAssist: CGFloat = 0
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let origin = CGPoint(x: contentOffset.x - leftAssist, y: contentOffset.y - topAssist)
        let size = CGSize(width: frame.width + leftAssist + rightAssist, height: frame.height + topAssist + bottomAssist)
        let extendedFrame = CGRect(origin: origin, size: size)
        
        if extendedFrame.contains(point) {
            for subview in subviews {
                guard subview.frame.contains(point) else { continue }
                return subview
            }
            return self
        }
        return nil
    }
}
