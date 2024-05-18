//
//  CollectionView.swift
//  StoryTunes
//
//  Created by Daniel Truong on 5/17/24.
//

import SwiftUI

struct CollectionView: View {
    @EnvironmentObject var collection: BadgeCollection
    @State private var isImageLoaded = false
    var body: some View {
        ZStack {
            ExtendedView()
            VStack {
                Spacer()
                Text("Collections")
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                List(collection.badges) { badge in
                    BadgeDesignView(track: badge.track, design: badge.design, fontName: badge.font, isImageLoaded: $isImageLoaded)
                        .listRowBackground(Color.clear)
                }
            }.listStyle(PlainListStyle())
                .background(Color.clear)
                .listRowBackground(Color.clear)
        }
    }

}
