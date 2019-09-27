//
//  Copyright © 2017 Rosberry. All rights reserved.
//

import Foundation

public protocol HasKeychainService {

    var keychainService: KeychainService { get }
}

public protocol KeychainService {

    func set(_ value: String?, forKey key: String)
    func get(_ key: String) -> String?

    func setData(_ value: Data?, forKey key: String)
    func getData(_ key: String) -> Data?
}
