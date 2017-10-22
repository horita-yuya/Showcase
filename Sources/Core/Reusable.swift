//
//  Reusable.swift
//  Pods
//
//  Created by 堀田 有哉 on 2017/08/24.
//
//

public protocol Reusable {
    func configure(with model: ReusableModel)
}

public protocol ReusableView: class, Reusable {
    associatedtype Model: ReusableModel
    func configure(with model: Model)
}

public extension ReusableView where Self: UIView {
    var index: Int {
        return tag
    }
    
    func configure(with model: ReusableModel) {
        guard let model = model as? Model else { return }
        configure(with: model)
    }
}

public protocol ReusableModel {}

