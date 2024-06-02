//
//  Created by belyenochi on 2024/05/30.
//

import Foundation

public protocol ModuleRoute {
    static func key() -> String
    func params() -> [String: Any]?
}

public extension ModuleRoute {
    static func key() -> String {
        return String(describing: type(of: self))
    }
    
    func params() -> [String : Any]? {
        return nil
    }
}
