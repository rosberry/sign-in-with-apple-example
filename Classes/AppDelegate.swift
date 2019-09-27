//
//  Copyright © 2019 Rosberry. All rights reserved.
//

import UIKit

typealias LaunchOptions = [UIApplication.LaunchOptionsKey: Any]

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var appCoordinator: AppCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: LaunchOptions?) -> Bool {
        AppConfigurator.configure()
        appCoordinator = .init(services: Services)
        appCoordinator?.start(launchOptions: launchOptions)
        return true
    }
}
