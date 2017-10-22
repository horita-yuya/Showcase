//
//  Showcase.swift
//  Pods
//
//  Created by 堀田 有哉 on 2017/08/21.
//
//

import UIKit

public class Showcase: UIView {
    fileprivate var reusableViews: [Reusable] = []
    fileprivate var reusableModels: [ReusableModel] = []
    fileprivate let indicesDeque: IndicesDeque = .init()
    
    fileprivate var pagingOffset: CGFloat = 0
    fileprivate var periodicPoint: CGPoint = .zero
    
    fileprivate dynamic var scrollView: ExtendedScrollView = .init()
    fileprivate var isReuseNeeded: Bool = true
    fileprivate var observer: NSKeyValueObservation?
    
    fileprivate var registerdObject: [String: AnyObject] = [:]
    
    fileprivate var visibleRect: CGRect {
        return .init(x: scrollView.contentOffset.x - scrollView.leftAssist,
                      y: scrollView.contentOffset.y - scrollView.topAssist,
                      width: frame.width,
                      height: frame.height)
    }
    
    fileprivate var reusableRect: CGRect {
        return .init(x: scrollView.contentOffset.x - scrollView.leftAssist - layout.itemSize.width - layout.lineSpacing,
                      y: scrollView.contentOffset.y - scrollView.topAssist - layout.itemSize.height - layout.lineSpacing,
                      width: frame.size.width + layout.itemSize.width * 2 + layout.lineSpacing * 2,
                      height: frame.size.height + layout.itemSize.height * 2 + layout.lineSpacing * 2)
    }
    
    public var layout: Layout = .init()
    public var scrollingHandler: (() -> ())?
    public var infiniteEfficient: Int = 10000
    public var isPagingEnabled: Bool = false
    
    public var centerIndex: Int = 0
    
    public var visibleViews: [UIView] {
        return reusableViews
            .flatMap { $0 as? UIView }
            .filter { $0.frame.intersects(visibleRect) }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    public func register<T: UIView>(byNibName nibName: T.Type) where T: Reusable {
        let identifier = String(describing: nibName.self)
        registerdObject[identifier] = UINib(nibName: identifier, bundle: nil)
    }
    
    public func register<T: UIView>(byClassName className: T.Type) where T: Reusable {
        let identifier = String(describing: className.self)
        registerdObject[identifier] = className
    }
    
    public func reset<T: UIView>(_ type: T.Type, models: [T.Model]) where T: ReusableView {
        configureScrollView()
        let identifier = String(describing: type.self)
        
        while let view = reusableViews.popLast() as? UIView {
            view.gestureRecognizers?.forEach { view.removeGestureRecognizer($0) }
            view.removeFromSuperview()
        }
        reusableModels = []
        indicesDeque.reset()
        
        instantiateSubviews(type, models: models, forCellWithReuseIdentifier: identifier)
    }
}

// MARK: Core

private extension Showcase {
    func configure() {
        clipsToBounds = true
    }
    
    func configureScrollView() {
        scrollView.removeFromSuperview()
        scrollView = ExtendedScrollView()
        addSubview(scrollView)
        
        observer = scrollView.observe(\.contentOffset) { [weak self] _ in
            self?.rearrange()
            self?.scrollingHandler?()
        }
        
        scrollView.isPagingEnabled = isPagingEnabled
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.scrollsToTop = false
        scrollView.clipsToBounds = false
        
        pagingOffset = layout.lineSpacing + (layout.direction == .horizontal ? layout.itemSize.width : layout.itemSize.height)
    }
    
    func rearrange() {
        centerIndex = indicesDeque.centerIndex
        
        reusableViews.forEach { reusableView in
            guard let view = reusableView as? UIView else { return }
            layout.update(visibleRect: isReuseNeeded ? reusableRect : visibleRect, rect: view.frame)
            
            let center = view.center
            view.center = layout.scrollPath(inVisibleRect: visibleRect, viewFrame: view.frame)
            
            if layout.transform != nil {
                view.layer.transform = layout.transformWithScroll(inVisibleRect: visibleRect, viewFrame: view.frame)
            }
            
            if !reusableRect.intersects(view.frame) {
                view.center = center
                view.isHidden = true
            } else {
                view.isHidden = false
            }

            switch layout.arrangement {
            case .left, .up:
                view.center -= periodicPoint
                view.isHidden = true
                
                if isReuseNeeded {
                    indicesDeque.enqueue(from: .head)
                    view.tag = indicesDeque.index(of: .head)
                    reusableView.configure(with: reusableModels[indicesDeque.index(of: .head)])
                }
                
            case .right, .down:
                view.center += periodicPoint
                view.isHidden = true
                
                if isReuseNeeded {
                    indicesDeque.enqueue(from: .tail)
                    view.tag = indicesDeque.index(of: .tail)
                    reusableView.configure(with: reusableModels[indicesDeque.index(of: .tail)])
                }
                
            case .stay:
                break
            }
        }
    }
    
    func instantiateSubviews<T: UIView>(_ type: T.Type, models: [T.Model], forCellWithReuseIdentifier identifier: String) where T: ReusableView {
        prepareForInstantiating()
        let itemCount = models.count
        layoutIfNeeded()
        
        models.enumerated().forEach { index, model in
            var viewFrame: CGRect = .init(x: scrollView.frame.width / 2 - layout.itemSize.width / 2,
                                          y: scrollView.frame.height / 2 - layout.itemSize.height / 2,
                                          width: layout.itemSize.width,
                                          height: layout.itemSize.height)
            
            switch layout.direction {
            case .horizontal:
                viewFrame.origin.x = pagingOffset * .init(index + infiniteEfficient) + layout.lineSpacing / 2
                viewFrame.origin.x -= reusableRect.intersects(viewFrame) ? 0 : pagingOffset * .init(itemCount)
                
            case .vertical:
                viewFrame.origin.y = pagingOffset * .init(index + infiniteEfficient) + layout.lineSpacing / 2
                viewFrame.origin.y -= reusableRect.intersects(viewFrame) ? 0 : pagingOffset * .init(itemCount)
            }
            
            if reusableRect.intersects(viewFrame) {
                guard let view = dequeueReusableView(identifier) as? T else { return }
                view.frame = viewFrame
                
                let center = view.center
                view.center = layout.scrollPath(inVisibleRect: visibleRect, viewFrame: viewFrame)
                view.layer.transform = layout.transformWithScroll(inVisibleRect: visibleRect, viewFrame: view.frame)
                
                if !reusableRect.intersects(view.frame) {
                    view.center = center
                    view.layer.transform = CATransform3DIdentity
                    view.isHidden = true
                }
                
                reusableViews.append(view)
                indicesDeque.add(index)
                scrollView.addSubview(view)
                
                view.tag = index
                view.configure(with: model)
            }
        }
        
        reusableModels = models
        isReuseNeeded = indicesDeque.count < models.count
        indicesDeque.configure(withMaximumIndex: models.count - 1)
        periodicPoint = layout.direction == .horizontal ? .init(x: pagingOffset * .init(reusableViews.count), y: 0) : .init(x: 0, y: pagingOffset * .init(reusableViews.count))
    }
}

// MARK: Utility

private extension Showcase {
    func prepareForInstantiating() {
        layoutIfNeeded()
        let widthC = layout.direction == .horizontal ? pagingOffset : frame.width
        let heightC = layout.direction == .vertical ? pagingOffset : frame.height
        
        scrollView.rightAssist = (frame.width - widthC) / 2
        scrollView.leftAssist = (frame.width - widthC) / 2
        scrollView.topAssist = (frame.height - heightC) / 2
        scrollView.bottomAssist = (frame.height - heightC) / 2
        
        scrollView.widthAnchor.constraint(equalToConstant: widthC).isActive = true
        scrollView.heightAnchor.constraint(equalToConstant: heightC).isActive = true
        scrollView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        scrollView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        scrollView.contentSize = layout.direction == .horizontal ? .init(width: pagingOffset * .init(infiniteEfficient) * 2, height: 1) : .init(width: 1, height: pagingOffset * .init(infiniteEfficient) * 2)
        scrollView.contentOffset = layout.direction == .horizontal ? .init(x: pagingOffset * .init(infiniteEfficient), y: 0) : .init(x: 0, y: pagingOffset * .init(infiniteEfficient))
    }
    
    func dequeueReusableView(_ identifier: String) -> UIView {
        var reuseView: UIView
        if let nib = registerdObject[identifier] as? UINib, let view = nib.instantiate(withOwner: nil, options: nil).first as? UIView {
            reuseView = view
        } else if let type = registerdObject[identifier] as? UIView.Type {
            reuseView = type.init(frame: frame)
        } else {
            fatalError(" - the identifier does not match with registered identifier, or any identifiers are not registered. Check 'reset' func in your code.")
        }
        
        return reuseView
    }
}
