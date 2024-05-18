//
//  CustomFontView.swift
//  StoryTunes
//
//  Created by Daniel Truong on 5/17/24.
//

import SwiftUI

struct FontItem {
    var name: String
    var displayName: String
}

struct FontsListView: View {
    @ObservedObject var viewModel = FontViewModel()
    @Binding var fontName: String
    var track: TrackItem
    
    var body: some View {
        List(viewModel.fonts, id: \.name) { font in
            VStack(alignment: .leading) {
                Text(font.displayName)
                    .font(.headline)
                    .onTapGesture {
                        fontName = font.name
                        viewModel.selectedFont = fontName
                    }
                Text(track.name)
                    .font(Font.custom(font.name, size: 18))
                Text(track.artists.first?.name ?? "Unknown Artist")
                    .font(Font.custom(font.name, size: 18))
            }
        }.frame(height: 200)
            .listStyle(PlainListStyle())
            .background(Color.white)
            .cornerRadius(/*@START_MENU_TOKEN@*/3.0/*@END_MENU_TOKEN@*/)
        .navigationTitle("Choose a Font")
    }
}

class FontViewModel: ObservableObject {
    @Published var fonts: [FontItem] = [
        FontItem(name: "Helvetica", displayName: "Helvetica"),
        FontItem(name: "Courier", displayName: "Courier"),
        FontItem(name: "Georgia", displayName: "Georgia"),
        // Add more fonts as needed
    ]
    @Published var selectedFont: String = "Helvetica"
}


struct CustomFontView: View {
    @ObservedObject var viewModel = BadgeViewModel()
    @ObservedObject var fontViewModel = FontViewModel()

    var track: TrackItem
    var design: String
    @State private var fontName: String = "Helvetica"
    @State private var isLinkActive = false

    var body: some View {
        ZStack {
            ExtendedView()
            VStack {
                Spacer()
                HStack(spacing: 20) {
                    // Track image
                    if let imageUrl = track.album.images.first?.url,
                       let url = URL(string: imageUrl) {
                        AsyncImage(url: url) { image in
                            image.resizable()
                        } placeholder: {
                            Color.black  // Placeholder if no image is available
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
                NavigationLink(destination: SaveBadgeView(track:track, design:design, fontName: fontName), isActive: $isLinkActive) {
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
                Text("Pick your font")
                    .font(.title3)
                    .padding()
                Image(systemName: "arrow.down")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .padding()
                FontsListView(fontName: $fontName, track: track)
            }
        }
    }
}
