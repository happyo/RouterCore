//
//  ContentView.swift
//  RouterCoreApp
//
//  Created by happyo on 2024/6/2.
//

import SwiftUI
import RouterCore

struct ContentView: View {
    @State private var currentRoute: PathRoute?
    @State private var navigationPath = NavigationPath()
    
    init() {
        use()
    }
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("Hello, world!")
                
                NavigationLink(destination: ModuleManager.shared.viewFor(route: HomePageRoute(name: "hahah"))) {
                    Text("Go to Detail View")
                }
                
                Button("Print home") {
                    ModuleManager.shared.performAction(route: HomePrintRoute(name: "haha"))
                }

                Button("Go next home") {
//                    navigationPath.append(PathRoute(router: HomePageRoute(name: "hahah")))
                    currentRoute = PathRoute(router: HomePageRoute(name: "hahah"))
                }

            }
            .navigationDestination(for: PathRoute.self) { route in
                AnyView(ModuleManager.shared.viewFor(route: route.router))
            }
            .padding()
        }
        .sheet(item: $currentRoute) { route in
            AnyView(ModuleManager.shared.viewFor(route: route.router))
        }
        
    }
    
    // Use
    func use() {
        // App loading
        HomeModule.setup()
        SettingModule.setup()
    }

}

#Preview {
    ContentView()
}

// HomeModule
public struct HomePage: View {
    public var name: String
    
    public init(name: String) {
        self.name = name
    }
    
    public var body: some View {
        
        Text("Home")
        Text(name)
//        Button("GoSetting") {
//            goSetting()
//        }
        NavigationLink(destination: ModuleManager.shared.viewFor(route: SettingRouter())) {
            Text("Go to setting View")
        }

    }
}

public class HomePageProvider: ModuleProvider {
    public init() {
        
    }
    
    public func createView(route: HomePageRoute) -> some View {
        HomePage(name: route.name)
    }
    
    
}

public class HomePrintProvider: ModuleProvider {
    
    public init() {
        
    }
    
    public func performAction(route: HomePrintRoute) {
        print(route.name)
    }
}


// SettingModule
public struct SettingPage: View {
    public init() {
        
    }

    public var body: some View {
        Text("Setting")
    }
}

public class SettingPageProvider: ModuleProvider {
    public init() {
        
    }
    
    
    public func createView(route: SettingRouter) -> some View {
        SettingPage()
    }
}

// RouterLayer

public struct HomePageRoute: ModuleRoute {
    public var name: String
    
    public init(name: String) {
        self.name = name
    }
    
    public func params() -> [String : Any]? {
        return ["name" : name]
    }
    
    
}

public struct HomePrintRoute: ModuleRoute {
    public var name: String
    
    public init(name: String) {
        self.name = name
    }
}

public struct SettingRouter: ModuleRoute {
    public init() {
        
    }
    
}

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
