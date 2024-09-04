//
//  Created by belyenochi on 2024/05/30.
//

import Foundation

public protocol ModuleRoute: Hashable {
    static func key() -> String
    static func isAction() -> Bool
}

public extension ModuleRoute {
    static func key() -> String {
        return String(describing: type(of: self))
    }

    static func isAction() -> Bool {
        return false
    }
}
