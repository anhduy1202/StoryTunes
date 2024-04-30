//
//  SlidingAnimationView.swift
//  StoryTunes
//
//  Created by Daniel Truong on 4/30/24.
//

import SwiftUI

struct SlidingAnimationView: View {
        let imagesRow1 = ["badge1", "badge2"]
        let imagesRow2 = ["badge3", "badge4"]
        // State to control the offset for both rows
        @State private var offsetRow1 = CGFloat.zero
        @State private var offsetRow2 = CGFloat.zero
        // Timers to change the offset
        let timerRow1 = Timer.publish(every: 0.03, on: .main, in: .common).autoconnect()
        let timerRow2 = Timer.publish(every: 0.03, on: .main, in: .common).autoconnect()

        var body: some View {
            GeometryReader { geometry in
                VStack(spacing: 12) {
                    Spacer()
                    HStack(spacing: 12) {
                        ForEach(imagesRow1, id: \.self) { img in
                            Image(img)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: geometry.size.width, height: 80)
                                .clipped()
                        }
                        ForEach(imagesRow1, id: \.self) { img in
                            Image(img)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: geometry.size.width, height: 80)
                                .clipped()
                        }
                    }
                    .offset(x: self.offsetRow1)
                    .onReceive(timerRow1) { _ in
                        withAnimation {
                            self.offsetRow1 -= 1
                        }
                        // Reset the offset to start when it reaches the end of the images
                        if abs(self.offsetRow1) > geometry.size.width {
                            self.offsetRow1 = 0
                        }
                    }

                    HStack(spacing: 12) {
                        ForEach(imagesRow2, id: \.self) { img in
                            Image(img)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: geometry.size.width, height: 80)
                                .clipped()
                        }
                        ForEach(imagesRow2, id: \.self) { img in
                            Image(img)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: geometry.size.width, height: 80)
                                .clipped()
                        }
                    }
                    .offset(x: self.offsetRow2)
                    .onReceive(timerRow2) { _ in
                        withAnimation {
                            self.offsetRow2 += 1
                        }
                        // Reset the offset to start when it reaches the end of the images
                        if self.offsetRow2 > 0 {
                            self.offsetRow2 = -geometry.size.width
                        }
                    }
                    Spacer()
                    
                }
            }
        }
}

#Preview {
    SlidingAnimationView()
}
