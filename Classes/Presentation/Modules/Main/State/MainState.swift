//
//  Copyright © 2019 Rosberry. All rights reserved.
//

final class MainState {

    var userID: String?
    var firstName: String?
    var familyName: String?
    var email: String?

    var userDescription: String {
        var description = ""

        if let userID = userID {
            description = "userID: \(userID)\n"
        }

        if let firstName = firstName {
            description += "name: \(firstName)\n"
        }

        if let familyName = familyName {
            description += "familyName: \(familyName)\n"
        }

        if let email = email {
            description += "email: \(email)"
        }
        return description
    }
}
