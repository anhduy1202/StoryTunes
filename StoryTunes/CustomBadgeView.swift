//
//  CustomBadgeView.swift
//  StoryTunes
//
//  Created by Daniel Truong on 5/17/24.
//

import SwiftUI

struct Badge {
    var name: String
    var image: String
}

class BadgeViewModel: ObservableObject {
    @Published var badges = [
        Badge(name: "Birthday Theme", image: "design1"),
        Badge(name: "Bunny", image: "design2"),
        Badge(name: "Tyler Meme", image: "design3"),
        Badge(name: "Lightning", image: "design4")
    ]
}

struct BadgeView: View {
    var badge: Badge
    
    var body: some View {
        VStack {
            HStack {
                Image(badge.image)
                    .resizable()
                    .scaledToFit()
                    .background(Color.clear)
                Spacer()
            }
            Text(badge.name)
                .font(.title2)
                .padding()
        }
        .background(Color.clear)
        .frame(height: 240)
        .cornerRadius(30)
    }
}

struct CustomBadgeView: View {
    @ObservedObject var viewModel = BadgeViewModel()
    var track: TrackItem
    var body: some View {
        ZStack {
            ExtendedView()
            VStack {
                HStack(spacing: 20) {
                    // Track image
                    if let imageUrl = track.album.images.first?.url,
                       let url = URL(string: imageUrl) {
                        AsyncImage(url: url) { image in
                            image.resizable()
                        } placeholder: {
                            Color.black  // Placeholder if no image is available
                        }
                        .frame(width: 100, height: 100)
                        .cornerRadius(10)
                    }
                    
                    // Track name and artist
                    VStack(alignment: .leading, spacing: 4) {
                        Text(track.name)
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text(track.artists.first?.name ?? "Unknown Artist")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 5)
                .padding()
                
                Spacer()  // Pushes everything to the top
                    .navigationTitle(track.name)
                    .padding()
                Text("Pick your badge")
                    .font(.title)
                    .padding()
                Image(systemName: "arrow.down")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .padding()
                List(viewModel.badges.indices, id: \.self) { index in
                    BadgeView(badge: viewModel.badges[index])
                        .listRowBackground(Color.clear)
                }
                .frame(height: 300)
                .listStyle(PlainListStyle())
                .background(Color.white)
                .cornerRadius(/*@START_MENU_TOKEN@*/3.0/*@END_MENU_TOKEN@*/)
            }
        }
    }
}
