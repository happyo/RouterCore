//
//  NavigationCoordinator.swift
//  RouterCore
//

import SwiftUI

public protocol PathRouteGeneratePlugin {
    func generatePathRoute(routeString: String) -> PathRoute?
}

public class NavigationNode: ObservableObject, Identifiable {
    public let id = UUID()
    @Published public var path = NavigationPath()
    public let currentRoute: PathRoute?
    @Published public var sheetItem: NavigationNode?
    @Published public var fullItem: NavigationNode?

    public init(currentRoute: PathRoute? = nil) {
        self.currentRoute = currentRoute
    }
}

@MainActor
public class NavigationCoordinator: ObservableObject {
    @Published public var rootNode: NavigationNode

    private var plugins: [any PathRouteGeneratePlugin] = []

    public var currentActiveNode: NavigationNode {
        var c = rootNode

        while let s = c.sheetItem {
            c = s
        }

        while let f = c.fullItem {
            c = f
        }

        return c
    }

    public init() {
        let node = NavigationNode()
        rootNode = node
    }

    public func registerPlugins(_ newPlugins: [any PathRouteGeneratePlugin]) {
        plugins.append(contentsOf: newPlugins)
    }

    public func triggerRoute(_ routeString: String) {
        if let pathRoute = generatePathRoute(routeString: routeString) {
            pushPathRoute(pathRoute)
        }
    }

    public func triggerRoute<Route: ModuleRoute>(_ route: Route) {
        let pathRoute = PathRoute(router: route)
        pushPathRoute(pathRoute)
    }

    public func sheetRoute<Route: ModuleRoute>(_ route: Route) {
        let pathRoute = PathRoute(router: route)
        sheetPathRoute(pathRoute)
    }

    public func sheetRoute(_ routeString: String) {
        if let pathRoute = generatePathRoute(routeString: routeString) {
            sheetPathRoute(pathRoute)
        }
    }

    public func fullRoute<Route: ModuleRoute>(_ route: Route) {
        let pathRoute = PathRoute(router: route)
        fullPathRoute(pathRoute)
    }

    public func fullRoute(_ routeString: String) {
        if let pathRoute = generatePathRoute(routeString: routeString) {
            fullPathRoute(pathRoute)
        }
    }

    public func pop() {
        let node = currentActiveNode
        if !node.path.isEmpty {
            node.path.removeLast()
        }
    }

    public func popToRoot() {
        rootNode.path.removeLast(rootNode.path.count)
        rootNode.sheetItem = nil
        rootNode.fullItem = nil
    }

    // MARK: - Private
    private func generatePathRoute(routeString: String) -> PathRoute? {
        for plugin in plugins {
            if let route = plugin.generatePathRoute(routeString: routeString) {
                return route
            }
        }
        return nil
    }

    private func triggeredPathRoute(_ pathRoute: PathRoute) -> PathRoute? {
        if pathRoute.router.isAction() {
            ModuleManager.shared.performAction(route: pathRoute.router)
            return nil
        } else {
            return pathRoute
        }
    }

    private func pushPathRoute(_ pathRoute: PathRoute) {
        if let triggeredRoute = triggeredPathRoute(pathRoute) {
            currentActiveNode.path.append(triggeredRoute)
        }
    }

    private func sheetPathRoute(_ pathRoute: PathRoute) {
        if let triggeredRoute = triggeredPathRoute(pathRoute) {
            let sheetItem = NavigationNode(currentRoute: triggeredRoute)
            currentActiveNode.sheetItem = sheetItem
        }
    }

    private func fullPathRoute(_ pathRoute: PathRoute) {
        if let triggeredRoute = triggeredPathRoute(pathRoute) {
            let fullItem = NavigationNode(currentRoute: triggeredRoute)
            currentActiveNode.fullItem = fullItem
        }
    }
}

public struct NavigationWrapperModifier: ViewModifier {
    @ObservedObject public var node: NavigationNode

    public init(node: NavigationNode) {
        self.node = node
    }

    public func body(content: Content) -> some View {
        NavigationStack(path: $node.path) {
            content
                .navigationDestination(for: PathRoute.self) { path in
                    AnyView(ModuleManager.shared.viewFor(route: path.router))
                }
        }
        .sheet(item: $node.sheetItem) { item in
            anyView(for: item)
                .modifier(NavigationWrapperModifier(node: item))
        }
        #if os(iOS)
        .fullScreenCover(item: $node.fullItem) { item in
            anyView(for: item)
                .modifier(NavigationWrapperModifier(node: item))
        }
        #else
        .sheet(item: $node.fullItem) { item in
            anyView(for: item)
                .modifier(NavigationWrapperModifier(node: item))
        }
        #endif
    }

    @ViewBuilder
    private func anyView(for item: NavigationNode) -> some View {
        if let router = item.currentRoute?.router {
            CommonRouterNavigationViewGenerator.normalView(for: router)
        } else {
            EmptyView()
        }
    }
}

extension View {
    public func navigationWrapper(node: NavigationNode) -> some View {
        self.modifier(NavigationWrapperModifier(node: node))
    }
}
