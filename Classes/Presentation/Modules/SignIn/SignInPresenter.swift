//
//  Copyright © 2019 Rosberry. All rights reserved.
//

final class SignInPresenter {

    typealias Dependencies = Any

    weak var view: SignInViewInput?
    weak var output: SignInModuleOutput?

    var state: SignInState

    private let dependencies: Dependencies

    init(state: SignInState, dependencies: Dependencies) {
        self.state = state
        self.dependencies = dependencies
    }
}

// MARK: - SignInViewOutput

extension SignInPresenter: SignInViewOutput {

    func viewDidLoad() {
        update(force: true, animated: false)
    }

    func signInWithAppleEventTriggered() {
        output?.signInModuleSignInWithAppleEventTriggered(self)
    }
}

// MARK: - SignInModuleInput

extension SignInPresenter: SignInModuleInput {

    func update(force: Bool = false, animated: Bool) {
        let viewModel = SignInViewModel(state: state)
        view?.update(with: viewModel, force: force, animated: animated)
    }
}
