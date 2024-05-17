//
//  TrackListView.swift
//  StoryTunes
//
//  Created by Daniel Truong on 5/17/24.
//

import SwiftUI

struct TracksListView: View {
    @EnvironmentObject var spotifySession: SpotifySession

    var body: some View {
        List(spotifySession.tracks, id: \.name) { track in
            HStack {
                if let imageUrl = track.album.images.first?.url,
                   let url = URL(string: imageUrl) {
                    AsyncImage(url: url) { image in
                        image.resizable()
                    } placeholder: {
                        Color.gray
                    }
                    .frame(width: 50, height: 50)
                    .cornerRadius(5)
                }
                VStack(alignment: .leading) {
                    Text(track.name)
                        .font(.headline)
                    Text(track.artists.first?.name ?? "Unknown Artist")
                        .font(.subheadline)
                }
            }.padding(.leading, 48)
                .padding(.trailing, 48)
                .background(Color.clear)
                .listRowBackground(Color.clear)
        }.background(Color.clear)
        .listStyle(PlainListStyle())

        }
}

