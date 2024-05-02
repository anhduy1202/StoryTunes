//
//  HomeView.swift
//  StoryTunes
//
//  Created by Daniel Truong on 4/30/24.
//

import SwiftUI

struct HomeView: View {
    @State private var searchText = ""
    var body: some View {
        NavigationView{
            ZStack {
                ExtendedView()
                VStack{
                    InputView(searchText:$searchText)
                    Spacer()
                }
            }
        }.navigationBarBackButtonHidden(true)
    }
}

struct ExtendedView: View {
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
    var body: some View {
        TextField("", text: $searchText)
            .placeholder(when: searchText.isEmpty) {
                Text("Search for songs")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
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
}

    
#Preview {
    HomeView()
}
