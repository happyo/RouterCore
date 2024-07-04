//
//  Created by belyenochi on 2024/05/30.
//

import Foundation

public protocol ModuleRoute {
    static func key() -> String
}

public extension ModuleRoute {
    static func key() -> String {
        return String(describing: type(of: self))
    }
}
