//
//  indicesQueue.swift
//  Pods
//
//  Created by Yuya Horita on 2017/09/03.
//
//

import Foundation

enum EnqueuePosition {
    case head
    case tail
}

class IndicesDeque {
    var deque: [Int] = []
    private var maximumIndex: Int = 0
    
    var count: Int {
        return deque.count
    }
    var centerIndex: Int {
        guard deque.indices ~= deque.count / 2 else { return 0 }
        return deque[deque.count / 2]
    }
    
    func add(_ index: Int) {
        deque.append(index)
    }
    
    func index(of position: EnqueuePosition) -> Int {
        switch position {
        case .head:
            return deque.first ?? 0
            
        case .tail:
            return deque.last ?? 0
        }
    }
    
    func enqueue(from position: EnqueuePosition) {
        switch position {
        case .head:
            deque.removeLast()
            deque.insert(index(of: .head) == 0 ? maximumIndex : index(of: .head) - 1, at: 0)
            
        case .tail:
            deque.removeFirst()
            deque.append(index(of: .tail) == maximumIndex ? 0 : index(of: .tail) + 1)
        }
    }
    
    func configure(withMaximumIndex index: Int) {
        let former = deque.prefix(deque.count / 2 + 1)
        let latter = deque.suffix(deque.count / 2)
        deque = .init(latter + former)
        maximumIndex = index
    }
    
    func reset() {
        deque = []
        maximumIndex = 0
    }
}
