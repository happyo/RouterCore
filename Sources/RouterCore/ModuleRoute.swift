//
//  Created by belyenochi on 2024/05/30.
//

import Foundation

public protocol ModuleRoute: Hashable {
    static func key() -> String
    func isAction() -> Bool
}

public extension ModuleRoute {
    static func key() -> String {
        return String(describing: type(of: self))
    }

    func isAction() -> Bool {
        return false
    }
}
