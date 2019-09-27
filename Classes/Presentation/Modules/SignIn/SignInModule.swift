//
//  Copyright © 2019 Rosberry. All rights reserved.
//

protocol SignInModuleInput: class {
    var state: SignInState { get }
    func update(force: Bool, animated: Bool)
}

protocol SignInModuleOutput: class {
    func signInModuleClosed(_ moduleInput: SignInModuleInput)
    func signInModuleSignInWithAppleEventTriggered(_ moduleInput: SignInModuleInput)
}

final class SignInModule {

    var input: SignInModuleInput {
        return presenter
    }
    var output: SignInModuleOutput? {
        get {
            return presenter.output
        }
        set {
            presenter.output = newValue
        }
    }
    let viewController: SignInViewController
    private let presenter: SignInPresenter

    init(state: SignInState = .init()) {
        let presenter = SignInPresenter(state: state, dependencies: [Any]())
        let viewModel = SignInViewModel(state: state)
        let viewController = SignInViewController(viewModel: viewModel, output: presenter)
        presenter.view = viewController
        self.viewController = viewController
        self.presenter = presenter
    }
}
