//
//  MainView.swift
//  StoryTunes
//
//  Created by Daniel Truong on 5/17/24.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            CollectionView()
                .tabItem {
                    Label("Collections", systemImage: "archivebox")
                }
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }.navigationBarBackButtonHidden(true)
    }
}

#Preview {
    MainView()
}
