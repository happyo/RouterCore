//
//  Created by belyenochi on 2024/05/30.
//

import SwiftUI

public struct PathRoute: Hashable, Equatable, Identifiable {
    public var id: Int {
        router.hashValue
    }
    
    public var router: any ModuleRoute
    
    public init(router: any ModuleRoute) {
        self.router = router
    }
    
    public static func ==(lhs: PathRoute, rhs: PathRoute) -> Bool {
        return lhs.router.hashValue == rhs.router.hashValue
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(router)
    }
}

public protocol ModuleRoute: Hashable {
    static func key() -> String
    func isAction() -> Bool
    func showSystemNavBar() -> Bool
    func clearBackground() -> Color?
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

    func clearBackground() -> Color? {
        nil
    }
}

//public extension ModuleRoute {
//    func eraseToAnyRoute() -> AnyModuleRoute {
//        return AnyModuleRoute(self)
//    }
//}
//
//public struct AnyModuleRoute: ModuleRoute, Identifiable {
//    public var id: Int {
//        _hashValue()
//    }
//    private let _key: () -> String
//    private let _isAction: () -> Bool
//    private let _showSystemNavBar: () -> Bool
//    private let _clearBackground: () -> Color?
//    private let _hashValue: () -> Int
//    private let _equals: (Any) -> Bool
//
//    public init<T: ModuleRoute>(_ route: T) {
//        _key = { T.key() }
//        _isAction = { route.isAction() }
//        _showSystemNavBar = { route.showSystemNavBar() }
//        _clearBackground = { route.clearBackground() }
//        _hashValue = { route.hashValue }
//        _equals = { other in
//            guard let otherRoute = other as? T else { return false }
//            return route == otherRoute
//        }
//    }
//
//    // Implementing ModuleRoute methods
//    public static func key() -> String {
//        fatalError("key() is not accessible on AnyModuleRoute directly")
//    }
//
//    public func isAction() -> Bool {
//        _isAction()
//    }
//
//    public func showSystemNavBar() -> Bool {
//        _showSystemNavBar()
//    }
//
//    public func clearBackground() -> Color? {
//        _clearBackground()
//    }
//
//    // Implementing Hashable
//    public static func == (lhs: AnyModuleRoute, rhs: AnyModuleRoute) -> Bool {
//        lhs._equals(rhs)
//    }
//
//    public func hash(into hasher: inout Hasher) {
//        hasher.combine(_hashValue())
//    }
//}
