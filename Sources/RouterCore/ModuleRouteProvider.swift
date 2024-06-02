//
//  Created by belyenochi on 2024/05/30.
//

import SwiftUI

public protocol ModuleProvider {
    associatedtype Content: View
    associatedtype RouteType: ModuleRoute
    
    func createView(route: RouteType) -> Content
    func performAction(route: RouteType)
}

public extension ModuleProvider {
    func performAction(route: RouteType) {
        
    }
    
    func createView(route: RouteType) -> EmptyView {
        EmptyView()
    }
}

public struct AnyModuleProvider<RouteType: ModuleRoute>: ModuleProvider {
    private let _createView: (RouteType) -> AnyView
    private let _performAction: (RouteType) -> Void

    public init<Provider: ModuleProvider>(_ provider: Provider) where Provider.RouteType == RouteType {
        _createView = { route in AnyView(provider.createView(route: route)) }
        _performAction = provider.performAction
    }

    public func createView(route: RouteType) -> AnyView {
        return _createView(route)
    }

    public func performAction(route: RouteType) {
        _performAction(route)
    }
}

