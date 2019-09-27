//
//  Copyright © 2017 Rosberry. All rights reserved.
//

import Foundation

typealias ServicesAlias = HasKeychainService

var Services: ServicesAlias { // swiftlint:disable:this variable_name
    return MainServicesFactory()
}

final class MainServicesFactory: ServicesAlias {
    lazy var keychainService: KeychainService = KeychainServiceImpl(withAppPrefix: "sign_in_test_")
}

// MARK: Singletons

private final class SingletonsPool {

}
