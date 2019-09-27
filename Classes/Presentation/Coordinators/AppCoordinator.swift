//
//  Copyright © 2019 Rosberry. All rights reserved.
//

import UIKit
import AuthenticationServices

final class AppCoordinator: BaseCoordinator<UIViewController> {

    var window: UIWindow?
    var dependencies: HasKeychainService
    weak var mainModuleInput: MainModuleInput?

    init(services: HasKeychainService) {
        self.dependencies = services
        let module = MainModule()
        mainModuleInput = module.input
        super.init(rootViewController: module.viewController)
        module.output = self
    }

    func start(launchOptions: LaunchOptions?) {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()

        showSignInModuleIfNeeded()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(signInWithAppleAuthorizationStatusChanged),
                                               name: ASAuthorizationAppleIDProvider.credentialRevokedNotification,
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationWillEnterForeground),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)
    }

    // MARK: - Private

    private func showSignInModuleIfNeeded() {
        if !handleCurrentUserAuthorizationState() {
            showSignInModule()
        }
    }

    private func showSignInModule() {
        let coordinator = SignInCoordinator(rootViewController: rootViewController, services: Services)
        coordinator.output = self
        append(child: coordinator)
        coordinator.start()
    }

    @objc private func applicationWillEnterForeground() {
        handleCurrentUserAuthorizationState()
    }

    @objc private func signInWithAppleAuthorizationStatusChanged() {
        handleCurrentUserAuthorizationState()
    }

    @discardableResult
    private func handleCurrentUserAuthorizationState() -> Bool {
        if let userID = dependencies.keychainService.get(.userID) {
            let provider = ASAuthorizationAppleIDProvider()
            provider.getCredentialState(forUserID: userID) { state, _ in
                switch state {
                    case .authorized:
                        // Nothing to do here
                        break
                    case .revoked:
                        DispatchQueue.main.async {
                            self.dependencies.keychainService.set(nil, forKey: .userID)
                            self.dependencies.keychainService.set(nil, forKey: .firstName)
                            self.dependencies.keychainService.set(nil, forKey: .familyName)
                            self.dependencies.keychainService.set(nil, forKey: .email)

                            let state = self.mainModuleInput?.state
                            state?.userID = nil
                            state?.firstName = nil
                            state?.familyName = nil
                            state?.email = nil
                            self.mainModuleInput?.update(force: false, animated: true)

                            self.showSignInModule()
                        }
                    case .notFound:
                        DispatchQueue.main.async {
                            self.showSignInModule()
                        }
                    default:
                        break
                }
            }
            return true
        }
        return false
    }
}

// MARK: - MainModuleOutput

extension AppCoordinator: MainModuleOutput {
    func mainModuleClosed(_ moduleInput: MainModuleInput) {

    }

    func mainModuleSignOutEventTriggered(_ moduleInput: MainModuleInput) {
        dependencies.keychainService.set(nil, forKey: .userID)
        showSignInModuleIfNeeded()
    }
}

// MARK: - SignInCoordinatorOutput

extension AppCoordinator: SignInCoordinatorOutput {
    func userSignedIn(with credential: ASAuthorizationAppleIDCredential) {
        let state = mainModuleInput?.state
        state?.userID = credential.user

        state?.firstName = credential.fullName?.givenName
        state?.familyName = credential.fullName?.familyName
        state?.email = credential.email

        dependencies.keychainService.set(state?.firstName, forKey: .firstName)
        dependencies.keychainService.set(state?.familyName, forKey: .familyName)
        dependencies.keychainService.set(state?.email, forKey: .email)

        mainModuleInput?.update(force: false, animated: true)
    }
}
