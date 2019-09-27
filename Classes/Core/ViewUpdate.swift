//
//  Copyright © 2018 Rosberry. All rights reserved.
//

import Foundation

public protocol ViewUpdate {

    var needsUpdate: Bool { get set }

    func update<T, U: Equatable>(new newViewModel: T,
                                 old oldViewModel: T,
                                 keyPath: KeyPath<T, U>,
                                 configurationBlock: (U) -> Void)
}

public extension ViewUpdate {

    func update<T, U: Equatable>(new newViewModel: T,
                                 old oldViewModel: T,
                                 keyPath: KeyPath<T, U>,
                                 configurationBlock: (U) -> Void) {
        let newValue = newViewModel[keyPath: keyPath]
        if needsUpdate {
            configurationBlock(newValue)
        }
        else if oldViewModel[keyPath: keyPath] != newValue {
            configurationBlock(newValue)
        }
    }
}

public protocol ForceViewUpdate {

    func update<T, U: Equatable>(new newViewModel: T,
                                 old oldViewModel: T,
                                 keyPath: KeyPath<T, U>,
                                 force: Bool,
                                 configurationBlock: (U) -> Void)
}

public extension ForceViewUpdate {

    func update<T, U: Equatable>(new newViewModel: T,
                                 old oldViewModel: T,
                                 keyPath: KeyPath<T, U>,
                                 force: Bool,
                                 configurationBlock: (U) -> Void) {
        let newValue = newViewModel[keyPath: keyPath]
        if force {
            configurationBlock(newValue)
        }
        else if oldViewModel[keyPath: keyPath] != newValue {
            configurationBlock(newValue)
        }
    }
}
