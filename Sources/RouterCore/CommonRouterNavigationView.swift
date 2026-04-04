//
//  CommonRouterNavigationView.swift
//  RouterCore
//

import SwiftUI

@MainActor
public struct CommonRouterNavigationViewGenerator {
    @ViewBuilder
    public static func navigationView(
        for route: any ModuleRoute,
        dismissAction: @escaping () -> Void,
        backButton: (() -> AnyView)? = nil
    ) -> some View {
        if route.isAction() {
            EmptyView()
        } else {
            if #available(iOS 16.4, *), let backgroundColor = route.clearBackground() {
                AnyView(ModuleManager.shared.viewFor(route: route))
                    .presentationBackground {
                        backgroundColor
                    }
            } else if route.showSystemNavBar() {
                NavigationStack {
                    AnyView(ModuleManager.shared.viewFor(route: route))
                        .toolbar {
                            #if os(iOS)
                                ToolbarItem(placement: .navigationBarLeading) {
                                    if let backButton = backButton {
                                        Button(action: dismissAction) {
                                            backButton()
                                        }
                                    } else {
                                        Button(action: dismissAction) {
                                            Text("Back")
                                                .font(.system(size: 14, weight: .semibold))
                                        }
                                    }
                                }
                            #else
                                ToolbarItem {
                                    if let backButton = backButton {
                                        Button(action: dismissAction) {
                                            backButton()
                                        }
                                    } else {
                                        Button(action: dismissAction) {
                                            Text("Back")
                                                .font(.system(size: 14, weight: .semibold))
                                        }
                                    }
                                }
                            #endif
                        }
                }
            } else {
                NavigationStack {
                    AnyView(ModuleManager.shared.viewFor(route: route))
                }
            }
        }
    }

    @ViewBuilder
    public static func normalView(for route: any ModuleRoute) -> some View {
        if route.isAction() {
            EmptyView()
        } else {
            AnyView(ModuleManager.shared.viewFor(route: route))
        }
    }
}
