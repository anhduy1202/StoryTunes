//
//  HomeView.swift
//  StoryTunes
//
//  Created by Daniel Truong on 4/30/24.
//

import SwiftUI
import Foundation

class AppSettings: ObservableObject {
    @Published var isDarkModeEnabled: Bool = false
}



struct HomeView: View {
    @State private var searchText = ""
    @EnvironmentObject var spotifySession:SpotifySession
    var body: some View {
        NavigationView{
            ZStack {
                ExtendedView()
                VStack{
                    InputView(searchText:$searchText)
                    Spacer()
                    TracksListView()
                }
            }
        }
            .onAppear {
                // Ensure the access token is fetched when the view appears
                if spotifySession.accessToken == nil {
                    spotifySession.fetchAccessToken()
                }
            }
            }
}

struct ExtendedView: View {
    @EnvironmentObject var appSettings: AppSettings
    var body: some View {
        BackgroundView(bgColor:"mainGrey", topRightCircles:["mainGreen","mainGreen"], topLeftCircle:"gradientPurple")
               VStack {
                   HStack {
                       Image("storytunesLogo")
                           .resizable()
                           .frame(width: 64, height: 64)
                           .alignmentGuide(.top) { _ in 0 }
                           .alignmentGuide(.leading) { _ in 9 }.padding(.leading,24)
                       Spacer()
                   }
                   Spacer()
               }
    }
}

struct InputView: View {
    @Binding var searchText: String
    @EnvironmentObject var spotifySession:SpotifySession
    var body: some View {
        TextField("", text: $searchText)
            .placeholder(when: searchText.isEmpty) {
                Text("Search for songs")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .onChange(of: searchText) { newValue in
                        searchSong(newValue)
                                }
            }
            .frame(height: 42)
            .padding(.leading, 8)
            .background(Color.gray)
            .foregroundColor(Color.white)
            .cornerRadius(8)
            .padding(.top, 120)
            .padding(.leading, 48)
            .padding(.trailing, 48)
            .overlay(
                HStack {
                    Spacer()
                    Image(systemName: "magnifyingglass")              .foregroundColor(.white)        .padding(.top, 120)
                        .padding(.trailing, 60)
                })
    }

    private func searchSong(_ query: String) {
        guard let token = spotifySession.accessToken, query.count > 3 else {
            print("Query must be at least three words or access token is unavailable.")
            return
        }
        spotifySession.fetchTracks(searchQuery: query)
    }

}


