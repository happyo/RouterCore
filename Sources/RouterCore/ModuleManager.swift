//
//  Created by belyenochi on 2024/05/30.
//
import SwiftUI

@MainActor
public protocol Module {
    static func setup()
}

@MainActor
public class ModuleManager {
    private var providers: [String: Any] = [:]

    public static let shared = ModuleManager()

    private init() {}

    public func registerProvider<Route: ModuleRoute, Provider: ModuleProvider>(_ provider: Provider) where Provider.RouteType == Route {
        providers[Route.key()] = AnyModuleProvider(provider)
    }

    private func providerFor<Route: ModuleRoute>(route: Route) -> AnyModuleProvider<Route>? {
        providers[Route.key()] as? AnyModuleProvider<Route>
    }
    
    @ViewBuilder
    public func viewFor<Route: ModuleRoute>(route: Route) -> some View {
        if let provider: AnyModuleProvider<Route> = providerFor(route: route) {
            provider.createView(route: route)
        } else {
            EmptyView()
        }
    }
    
    public func performAction<Route: ModuleRoute>(route: Route) {
        if let provider: AnyModuleProvider<Route> = providerFor(route: route) {
            provider.performAction(route: route)
        }
    }
}



