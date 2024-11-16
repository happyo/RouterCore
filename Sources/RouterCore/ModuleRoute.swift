//
//  Created by belyenochi on 2024/05/30.
//

import Foundation

public protocol ModuleRoute: Hashable {
    static func key() -> String
    func isAction() -> Bool
    func showSystemNavBar() -> Bool
    func isClearBackground() -> Bool
}

public extension ModuleRoute {
    static func key() -> String {
        return String(describing: type(of: self))
    }

    func isAction() -> Bool {
        return false
    }

    func showSystemNavBar() -> Bool {
        return false
    }

    func isClearBackground() -> Bool {
        return false
    }
}

public extension ModuleRoute {
    func eraseToAnyRoute() -> AnyModuleRoute {
        return AnyModuleRoute(self)
    }
}

public struct AnyModuleRoute: ModuleRoute, Identifiable {
    public var id: Int {
        _hashValue()
    }
    private let _key: () -> String
    private let _isAction: () -> Bool
    private let _showSystemNavBar: () -> Bool
    private let _isClearBackground: () -> Bool
    private let _hashValue: () -> Int
    private let _equals: (Any) -> Bool

    public init<T: ModuleRoute>(_ route: T) {
        _key = { T.key() }
        _isAction = { route.isAction() }
        _showSystemNavBar = { route.showSystemNavBar() }
        _isClearBackground = { route.isClearBackground() }
        _hashValue = { route.hashValue }
        _equals = { other in
            guard let otherRoute = other as? T else { return false }
            return route == otherRoute
        }
    }

    // Implementing ModuleRoute methods
    public static func key() -> String {
        fatalError("key() is not accessible on AnyModuleRoute directly")
    }

    public func isAction() -> Bool {
        _isAction()
    }

    public func showSystemNavBar() -> Bool {
        _showSystemNavBar()
    }

    // Implementing Hashable
    public static func == (lhs: AnyModuleRoute, rhs: AnyModuleRoute) -> Bool {
        lhs._equals(rhs)
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(_hashValue())
    }
}
