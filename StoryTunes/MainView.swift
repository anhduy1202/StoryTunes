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
            Text("Collections")
                .tabItem {
                    Label("Collections", systemImage: "archivebox")
                }
            Text("Settings")
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }.navigationBarBackButtonHidden(true)
    }
}

#Preview {
    MainView()
}
