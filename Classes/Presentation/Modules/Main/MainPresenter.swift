//
//  Copyright © 2019 Rosberry. All rights reserved.
//

final class MainPresenter {

    typealias Dependencies = HasKeychainService

    weak var view: MainViewInput?
    weak var output: MainModuleOutput?

    var state: MainState

    private let dependencies: Dependencies

    init(state: MainState, dependencies: Dependencies) {
        self.state = state
        self.dependencies = dependencies

        state.userID = dependencies.keychainService.get(.userID)
        state.firstName = dependencies.keychainService.get(.firstName)
        state.familyName = dependencies.keychainService.get(.familyName)
        state.email = dependencies.keychainService.get(.email)
    }
}

// MARK: - MainViewOutput

extension MainPresenter: MainViewOutput {

    func viewDidLoad() {
        update(force: true, animated: false)
    }

    func signOutEventTriggered() {
        output?.mainModuleSignOutEventTriggered(self)
    }
}

// MARK: - MainModuleInput

extension MainPresenter: MainModuleInput {

    func update(force: Bool = false, animated: Bool) {
        let viewModel = MainViewModel(state: state)
        view?.update(with: viewModel, force: force, animated: animated)
    }
}
