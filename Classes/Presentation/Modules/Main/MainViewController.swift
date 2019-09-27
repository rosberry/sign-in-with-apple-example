//
//  Copyright © 2019 Rosberry. All rights reserved.
//

import UIKit

protocol MainViewInput: class {
    func update(with viewModel: MainViewModel, force: Bool, animated: Bool)
}

protocol MainViewOutput: class {
    func viewDidLoad()
    func signOutEventTriggered()
}

final class MainViewController: UIViewController {

    private var viewModel: MainViewModel
    private let output: MainViewOutput

    // MARK: - Subviews

    private lazy var userDescriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()

    private lazy var signOutButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(signOutButtonPressed), for: .touchUpInside)
        button.setTitle("Sign out", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.tintColor = .red
        return button
    }()

    // MARK: - Lifecycle

    init(viewModel: MainViewModel, output: MainViewOutput) {
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
        view.addSubview(signOutButton)
        view.addSubview(userDescriptionLabel)
        output.viewDidLoad()
    }

    // MARK: - Layout

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        signOutButton.sizeToFit()
        signOutButton.frame.origin = .init(x: (view.bounds.width - signOutButton.bounds.width) / 2,
                                           y: view.bounds.height - signOutButton.bounds.height - view.safeAreaInsets.bottom)

        userDescriptionLabel.frame = .init(x: 12,
                                           y: view.safeAreaInsets.top,
                                           width: view.bounds.width - 2 * 12,
                                           height: signOutButton.frame.maxY - view.safeAreaInsets.top)
    }

    // MARK: - Actions

    @objc func signOutButtonPressed() {
        output.signOutEventTriggered()
    }
}

// MARK: - MainViewInput

extension MainViewController: MainViewInput, ForceViewUpdate {

    func update(with viewModel: MainViewModel, force: Bool, animated: Bool) {
        let oldViewModel = self.viewModel
        self.viewModel = viewModel

        update(new: viewModel, old: oldViewModel, keyPath: \.userDescription, force: force) { userDescription in
            userDescriptionLabel.text = userDescription
            view.setNeedsLayout()
            view.layoutIfNeeded()
        }
    }
}
