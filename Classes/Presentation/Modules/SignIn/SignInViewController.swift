//
//  Copyright © 2019 Rosberry. All rights reserved.
//

import UIKit
import AuthenticationServices

protocol SignInViewInput: class {
    func update(with viewModel: SignInViewModel, force: Bool, animated: Bool)
}

protocol SignInViewOutput: class {
    func viewDidLoad()
    func signInWithAppleEventTriggered()
}

final class SignInViewController: UIViewController {

    private var viewModel: SignInViewModel
    private let output: SignInViewOutput

    // MARK: - Subviews

    private lazy var signInButton: ASAuthorizationAppleIDButton = {
        let button = ASAuthorizationAppleIDButton()
        button.addTarget(self, action: #selector(signInButtonPressed), for: .touchUpInside)
        return button
    }()

    // MARK: - Lifecycle

    init(viewModel: SignInViewModel, output: SignInViewOutput) {
        self.viewModel = viewModel
        self.output = output
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        view.addSubview(signInButton)

        output.viewDidLoad()
    }

    // MARK: - Layout

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        signInButton.frame.size = .init(width: 140, height: 30)
        signInButton.center = view.center
    }

    // MARK: - Actions

    @objc private func signInButtonPressed() {
        output.signInWithAppleEventTriggered()
    }
}

// MARK: - SignInViewInput

extension SignInViewController: SignInViewInput, ForceViewUpdate {

    func update(with viewModel: SignInViewModel, force: Bool, animated: Bool) {
        let oldViewModel = self.viewModel
        self.viewModel = viewModel

        // update view
    }
}
