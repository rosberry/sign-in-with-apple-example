//
//  Copyright © 2017 Rosberry. All rights reserved.
//

import KeychainSwift

public final class KeychainServiceImpl: KeychainService {

    let keychain: KeychainSwift

    public init(withAppPrefix appPrefix: String) {
        keychain = KeychainSwift(keyPrefix: appPrefix)
    }

    public func set(_ value: String?, forKey key: String) {
        if let value = value {
            keychain.set(value, forKey: key)
        }
        else {
            keychain.delete(key)
        }
    }

    public func get(_ key: String) -> String? {
        keychain.get(key)
    }

    public func setData(_ value: Data?, forKey key: String) {
        if let value = value {
            keychain.set(value, forKey: key)
        }
        else {
            keychain.delete(key)
        }
    }

    public func getData(_ key: String) -> Data? {
        keychain.getData(key)
    }
}
