//
//  Copyright © 2019 Rosberry. All rights reserved.
//

import AuthenticationServices

final class SignInWithAppleDelegate: NSObject {

    let window: UIWindow
    let authorizationCompletedHandler: (ASAuthorizationController, ASAuthorization) -> Void
    let authorizationFailedHandler: (ASAuthorizationController, Error) -> Void

    init(window: UIWindow,
         authorizationCompletedHandler: @escaping (ASAuthorizationController, ASAuthorization) -> Void,
         authorizationFailedHandler: @escaping (ASAuthorizationController, Error) -> Void) {
        self.window = window
        self.authorizationCompletedHandler = authorizationCompletedHandler
        self.authorizationFailedHandler = authorizationFailedHandler
        super.init()
    }
}

// MARK: - ASAuthorizationControllerDelegate

extension SignInWithAppleDelegate: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        authorizationCompletedHandler(controller, authorization)
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        authorizationFailedHandler(controller, error)
    }
}

// MARK: - ASAuthorizationControllerPresentationContextProviding

extension SignInWithAppleDelegate: ASAuthorizationControllerPresentationContextProviding {
    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        window
    }
}
