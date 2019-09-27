//
//  Copyright © 2019 Rosberry. All rights reserved.
//

import UIKit
import AuthenticationServices

protocol SignInCoordinatorOutput: AnyObject {
    func userSignedIn(with credential: ASAuthorizationAppleIDCredential)
}

final class SignInCoordinator: BaseCoordinator<UIViewController> {

    let services: HasKeychainService
    weak var output: SignInCoordinatorOutput?

    // swiftlint:disable:next weak_delegate
    lazy var signInWithAppleDelegate: SignInWithAppleDelegate = {
        SignInWithAppleDelegate(window: rootViewController.view.window!,
                                authorizationCompletedHandler: { [weak self] controller, authorization in
                                    self?.signInWithAppleAuthorizationCompleted(from: controller, with: authorization)
                                }, authorizationFailedHandler: { [weak self] controller, error in
                                    self?.signInWithAppleAuthorizationFailed(from: controller, with: error)
                                })
    }()

    // swiftlint:disable:next weak_delegate
    lazy var iCloudCredentialsDelegate: SignInWithAppleDelegate = {
        SignInWithAppleDelegate(window: rootViewController.view.window!,
                                authorizationCompletedHandler: { [weak self] controller, authorization in
                                    self?.iCloudCredentialsSearchCompleted(from: controller, with: authorization)
                                }, authorizationFailedHandler: { [weak self] controller, error in
                                    self?.iCloudCredentialsSearchFailed(from: controller, with: error)
                                })
    }()

    init(rootViewController: UIViewController, services: HasKeychainService) {
        self.services = services
        super.init(rootViewController: rootViewController)
    }

    func start() {
        let module = SignInModule()
        module.output = self
        rootViewController.present(module.viewController, animated: true)
        checkICloudCredentialsExistence()
    }

    // MARK: - Private

    func checkICloudCredentialsExistence() {
        // Prepare requests for both Apple ID and password providers.
        let requests = [ASAuthorizationAppleIDProvider().createRequest(),
                        ASAuthorizationPasswordProvider().createRequest()]

        // Create an authorization controller with the given requests.
        let authorizationController = ASAuthorizationController(authorizationRequests: requests)
        authorizationController.delegate = iCloudCredentialsDelegate
        authorizationController.presentationContextProvider = iCloudCredentialsDelegate
        authorizationController.performRequests()
    }

    private func handle(_ credential: ASAuthorizationAppleIDCredential) {
        services.keychainService.set(credential.user, forKey: .userID)
        output?.userSignedIn(with: credential)
        close()
    }

    func close() {
        rootViewController.dismiss(animated: true)
        delegate?.childCoordinatorDidFinish(self)
    }
}

// MARK: - SignInModuleOutput

extension SignInCoordinator: SignInModuleOutput {
    func signInModuleClosed(_ moduleInput: SignInModuleInput) {
        close()
    }

    func signInModuleSignInWithAppleEventTriggered(_ moduleInput: SignInModuleInput) {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = signInWithAppleDelegate
        authorizationController.presentationContextProvider = signInWithAppleDelegate
        authorizationController.performRequests()
    }
}

// MARK: - Sign In with Apple handling

extension SignInCoordinator {
    func signInWithAppleAuthorizationCompleted(from controller: ASAuthorizationController, with authorization: ASAuthorization) {
        if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
            handle(credential)
        }
    }

    func signInWithAppleAuthorizationFailed(from controller: ASAuthorizationController, with error: Error) {
        print("Sign in with apple failed with error\n\(error)")
    }
}

// MARK: - iCloud credentials handling

extension SignInCoordinator {
    func iCloudCredentialsSearchCompleted(from controller: ASAuthorizationController, with authorization: ASAuthorization) {
        if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
            handle(credential)
        }
        else if let credential = authorization.credential as? ASPasswordCredential {
            let username = credential.user
            let password = credential.password
            print("Show application's sign in module with username \(username) and password \(password)")
        }
    }

    func iCloudCredentialsSearchFailed(from controller: ASAuthorizationController, with error: Error) {
        print("iCloud credentials search failed with error\n\(error)")
    }
}
