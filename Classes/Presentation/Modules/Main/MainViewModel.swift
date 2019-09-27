//
//  Copyright © 2019 Rosberry. All rights reserved.
//

final class MainViewModel {

    let userDescription: String

    init(state: MainState) {
        userDescription = state.userDescription
    }
}
