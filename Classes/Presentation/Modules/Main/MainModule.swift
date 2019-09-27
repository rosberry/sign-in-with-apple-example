//
//  Copyright © 2019 Rosberry. All rights reserved.
//

protocol MainModuleInput: class {
    var state: MainState { get }
    func update(force: Bool, animated: Bool)
}

protocol MainModuleOutput: class {
    func mainModuleClosed(_ moduleInput: MainModuleInput)
    func mainModuleSignOutEventTriggered(_ moduleInput: MainModuleInput)
}

final class MainModule {

    var input: MainModuleInput {
        return presenter
    }
    var output: MainModuleOutput? {
        get {
            return presenter.output
        }
        set {
            presenter.output = newValue
        }
    }
    let viewController: MainViewController
    private let presenter: MainPresenter

    init(state: MainState = .init()) {
        let presenter = MainPresenter(state: state, dependencies: Services)
        let viewModel = MainViewModel(state: state)
        let viewController = MainViewController(viewModel: viewModel, output: presenter)
        presenter.view = viewController
        self.viewController = viewController
        self.presenter = presenter
    }
}
