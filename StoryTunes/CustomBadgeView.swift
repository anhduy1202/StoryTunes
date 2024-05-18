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
    @Published var selectedDesign: String = "design1"
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
    @State private var isLinkActive = false
    @State private var isImageLoaded = false
    var track: TrackItem
    var body: some View {
        ZStack {
            ExtendedView()
            VStack {
                Spacer()
                BadgeDesignView(track: track, design: viewModel.selectedDesign, fontName: "Helvetica", isImageLoaded: $isImageLoaded)
                NavigationLink(destination: CustomFontView(track: track, design: viewModel.selectedDesign), isActive: $isLinkActive) {
                    Button("Continue") {
                        isLinkActive = true
                    }.foregroundColor(.white)
                    .padding()
                    .background(Color.black)
                    .cornerRadius(10)
                    .font(.headline)
                }
                    .navigationTitle(track.name)
                    .padding()
                Text("Pick your badge")
                    .font(.title3)
                    .padding()
                Image(systemName: "arrow.down")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .padding()
                List(viewModel.badges.indices, id: \.self) { index in
                    BadgeView(badge: viewModel.badges[index])
                        .listRowBackground(Color.clear)
                        .onTapGesture {
                            viewModel.selectedDesign = viewModel.badges[index].image
                        }
                }
                .frame(height: 200)
                .listStyle(PlainListStyle())
                .background(Color.white)
                .cornerRadius(/*@START_MENU_TOKEN@*/3.0/*@END_MENU_TOKEN@*/)
            }
        }
    }
}

struct BadgeDesignView: View {
    @ObservedObject var viewModel = BadgeViewModel()
    var track: TrackItem
    var design: String
    var fontName: String
    
    @Binding var isImageLoaded: Bool
    var body: some View {
        HStack(spacing: 20) {
            Spacer()
            if let imageUrl = track.album.images.first?.url, let url = URL(string: imageUrl) {
                AsyncImage(url: url) { phase in
                    if let image = phase.image {
                        image.resizable()
                            .onAppear { isImageLoaded = true }
                    } else if phase.error != nil {
                        Color.red // Indicates an error
                    } else {
                        Color.black // Placeholder if no image is available
                    }
                }
                .frame(width: 80, height: 80)
                .cornerRadius(10)
            }
            
            // Track name and artist
            VStack(alignment: .leading, spacing: 4) {
                Text(track.name)
                    .font(.custom(fontName, size: 20))
                    .fontWeight(.bold)
                
                Text(track.artists.first?.name ?? "Unknown Artist")
                    .font(.custom(fontName, size: 20))
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .background(
            Image(design)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .cornerRadius(10)
        )
        .cornerRadius(10)
        .shadow(radius: 5)
        .padding()
    }
}
