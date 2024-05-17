//
//  ContentView.swift
//  StoryTunes
//
//  Created by Daniel Truong on 4/28/24.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView(bgColor:"mainGrey", topRightCircles:["gradientYellow","gradientPink"], topLeftCircle:"gradientPurple")
                VStack {
                    HeroView()
                    SlidingAnimationView()
                    NavigationLink(destination: MainView()) {
                        HStack {
                            Text("Get Started")
                            Image(systemName: "arrow.forward")
                        }
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.black)
                            .cornerRadius(10)
                            .font(.headline)
                    }
                }
            }
        }
    }
}

struct HeroView: View {
    var body: some View {
        VStack{
            Spacer()
            Image("storytunesLogo").resizable().frame(width: 128, height: 128)
            Text("StoryTunes")
                .font(.largeTitle.weight(.bold))
                .foregroundStyle(.black).padding(.bottom,6)
            Text("Custom your music story")
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.black)
        }
    }
}

struct BackgroundView: View {
    let bgColor: String
    let topRightCircles: [String]
    let topLeftCircle: String
    var body: some View {
        Color(bgColor)
            .ignoresSafeArea()
        HStack {
             VStack {
                 Circle()
                     .fill(RadialGradient(gradient: Gradient(colors: [Color(topLeftCircle).opacity(0.8), Color(topLeftCircle).opacity(0.3)]), center: .center, startRadius: 50, endRadius: 70))
                     .frame(width: 200, height: 200)
                     .blur(radius: 30)
                      .padding(.top, 70)
                      .padding(.leading, -80)
                 Spacer()
             }
            Spacer()
             VStack {
                 Circle()
                     .fill(RadialGradient(gradient: Gradient(colors: [Color(topRightCircles[0]).opacity(1), Color(topRightCircles[1]).opacity(0.5)]), center: .center, startRadius: 10, endRadius: 90))
                     .frame(width: 200, height: 200)
                     .blur(radius: 30)
                     .padding(.trailing, -80)
                 Spacer()
             }
         }
    }
}

#Preview {
    ContentView()
}

