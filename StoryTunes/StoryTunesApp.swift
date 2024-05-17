//
//  StoryTunesApp.swift
//  StoryTunes
//
//  Created by Daniel Truong on 4/28/24.
//

import SwiftUI

@main
struct StoryTunesApp: App {
    var spotifySession = SpotifySession()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(spotifySession)
        }
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}
