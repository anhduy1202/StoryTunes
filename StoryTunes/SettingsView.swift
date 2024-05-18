//
//  SettingsView.swift
//  StoryTunes
//
//  Created by Daniel Truong on 5/18/24.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var settings: AppSettings
    
    var body: some View {
        NavigationView {
            Form {
                Toggle("Enable Dark Mode", isOn: $settings.isDarkModeEnabled)
                    .onChange(of: settings.isDarkModeEnabled) { newValue in
                        UIApplication.shared.windows.first?.rootViewController?.overrideUserInterfaceStyle = newValue ? .dark : .light
                    }
            }
            .navigationTitle("Settings")
        }
    }
}

