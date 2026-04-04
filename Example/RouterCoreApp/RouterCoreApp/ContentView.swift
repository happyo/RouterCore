//
//  ContentView.swift
//  RouterCoreApp
//
//  Created by happyo on 2024/6/2.
//

import SwiftUI
import RouterCore

// MARK: - Routes

public struct HomePageRoute: ModuleRoute {
    public var name: String

    public init(name: String) {
        self.name = name
    }
}

public struct HomePrintRoute: ModuleRoute {
    public var name: String

    public init(name: String) {
        self.name = name
    }

    public func isAction() -> Bool { true }
}

public struct SettingRouter: ModuleRoute {
    public init() {}

    public func showSystemNavBar() -> Bool { true }
}

public struct ProfileRoute: ModuleRoute {
    public var username: String

    public init(username: String) {
        self.username = username
    }
}

// MARK: - Pages

public struct HomePage: View {
    public var name: String
    @EnvironmentObject var coordinator: NavigationCoordinator

    public var body: some View {
        VStack(spacing: 16) {
            Text("Home Page")
                .font(.title)
            Text("Hello, \(name)")

            Button("Push Setting") {
                coordinator.triggerRoute(SettingRouter())
            }

            Button("Sheet Profile") {
                coordinator.sheetRoute(ProfileRoute(username: name))
            }

            #if os(iOS)
            Button("FullScreen Profile") {
                coordinator.fullRoute(ProfileRoute(username: name))
            }
            #endif

            Button("Print Action (no navigation)") {
                coordinator.triggerRoute(HomePrintRoute(name: name))
            }

            Button("Pop") {
                coordinator.pop()
            }
            .foregroundStyle(.red)
        }
        .padding()
    }
}

public struct SettingPage: View {
    @Environment(\.dismiss) private var dismiss

    public var body: some View {
        VStack(spacing: 16) {
            Text("Setting Page")
                .font(.title)
            Text("showSystemNavBar = true")
                .foregroundStyle(.secondary)
        }
        .padding()
    }
}

public struct ProfilePage: View {
    public var username: String
    @Environment(\.dismiss) private var dismiss

    public var body: some View {
        VStack(spacing: 16) {
            Text("Profile Page")
                .font(.title)
            Text("User: \(username)")

            Button("Dismiss") {
                dismiss()
            }
        }
        .padding()
    }
}

// MARK: - Providers

public class HomePageProvider: ModuleProvider {
    public init() {}

    public func createView(route: HomePageRoute) -> some View {
        HomePage(name: route.name)
    }
}

public class HomePrintProvider: ModuleProvider {
    public init() {}

    public func performAction(route: HomePrintRoute) {
        print("Action: \(route.name)")
    }
}

public class SettingPageProvider: ModuleProvider {
    public init() {}

    public func createView(route: SettingRouter) -> some View {
        SettingPage()
    }
}

public class ProfilePageProvider: ModuleProvider {
    public init() {}

    public func createView(route: ProfileRoute) -> some View {
        ProfilePage(username: route.username)
    }
}

// MARK: - Modules

public struct HomeModule: Module {
    public static func setup() {
        ModuleManager.shared.registerProvider(HomePageProvider())
        ModuleManager.shared.registerProvider(HomePrintProvider())
    }
}

public struct SettingModule: Module {
    public static func setup() {
        ModuleManager.shared.registerProvider(SettingPageProvider())
    }
}

public struct ProfileModule: Module {
    public static func setup() {
        ModuleManager.shared.registerProvider(ProfilePageProvider())
    }
}

// MARK: - Plugin Demo

struct DemoRoutePlugin: PathRouteGeneratePlugin {
    func generatePathRoute(routeString: String) -> PathRoute? {
        switch routeString {
        case "home":
            return PathRoute(router: HomePageRoute(name: "from plugin"))
        case "setting":
            return PathRoute(router: SettingRouter())
        case "profile":
            return PathRoute(router: ProfileRoute(username: "plugin user"))
        default:
            return nil
        }
    }
}

// MARK: - ContentView

struct ContentView: View {
    @StateObject private var coordinator = NavigationCoordinator()

    init() {
        HomeModule.setup()
        SettingModule.setup()
        ProfileModule.setup()
    }

    var body: some View {
        VStack(spacing: 20) {
            Text("RouterCore Demo")
                .font(.largeTitle.bold())

            Group {
                Section("Push / Sheet / FullScreen") {
                    Button("Push Home") {
                        coordinator.triggerRoute(HomePageRoute(name: "world"))
                    }

                    Button("Sheet Setting") {
                        coordinator.sheetRoute(SettingRouter())
                    }

                    #if os(iOS)
                    Button("FullScreen Profile") {
                        coordinator.fullRoute(ProfileRoute(username: "test"))
                    }
                    #endif
                }

                Section("String Route (Plugin)") {
                    Button("Trigger 'home'") {
                        coordinator.triggerRoute("home")
                    }

                    Button("Trigger 'setting'") {
                        coordinator.triggerRoute("setting")
                    }
                }

                Section("Action Route") {
                    Button("Print Action (no navigation)") {
                        coordinator.triggerRoute(HomePrintRoute(name: "hello"))
                    }
                }

                Button("Pop to Root") {
                    coordinator.popToRoot()
                }
                .foregroundStyle(.red)
            }
            .buttonStyle(.bordered)
        }
        .padding()
        .navigationWrapper(node: coordinator.rootNode)
        .environmentObject(coordinator)
        .onAppear {
            coordinator.registerPlugins([DemoRoutePlugin()])
        }
    }
}

#Preview {
    ContentView()
}
