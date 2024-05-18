//
//  SaveBadgeView.swift
//  StoryTunes
//
//  Created by Daniel Truong on 5/17/24.
//

import SwiftUI

class BadgeCollection: ObservableObject {
    @Published var badges: [SavedBadge] = []

    func addBadge(design: String, font: String, track: TrackItem) {
        let newBadge = SavedBadge(design: design, font: font, track: track)
        badges.append(newBadge)
    }

    func removeBadge(at offsets: IndexSet) {
        badges.remove(atOffsets: offsets)
    }
}

struct SavedBadge: Identifiable {
    var id = UUID()
    var design: String
    var font: String
    var track: TrackItem
}

struct SaveBadgeView: View {
    @ObservedObject var viewModel = BadgeViewModel()
    @ObservedObject var fontViewModel = FontViewModel()
    @EnvironmentObject var collection: BadgeCollection
    var track: TrackItem
    var design: String
    var fontName: String
    @State var myImage: UIImage?
    @State var image: Image?
    @State private var isImageLoaded = false
    var badgeView: some View {
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
    var body: some View {
        ZStack {
            ExtendedView()
            VStack {
                Text("Tadaa !!")
                    .font(.title)
                    .bold()
                    .padding()
                Text("Here’s your badge")
                    .font(.title2)
                    .padding()
                BadgeDesignView(track: track, design: design, fontName: fontName, isImageLoaded: $isImageLoaded)
                let _ = DispatchQueue.main.async {
                    myImage = BadgeDesignView(track: track, design: design, fontName: fontName, isImageLoaded: $isImageLoaded).UIsnapshot()
                }
                Image(systemName: "square.and.arrow.down")
                    .resizable()
                    .frame(width: 40, height: 40)
                Button("Save to image") {
                    if isImageLoaded {
                        image = BadgeDesignView(track: track, design: design, fontName: fontName, isImageLoaded: $isImageLoaded).snapshot()
                        let uiImage = image.asUIImage()
                        if let myImage {
                            UIImageWriteToSavedPhotosAlbum(myImage, nil, nil, nil)
                        }
                    }
                }.foregroundColor(.white)
                    .padding()
                    .background(Color.black)
                    .cornerRadius(10)
                    .font(.headline)
                    .padding(.bottom, 24)
                Image(systemName: "archivebox")
                    .resizable()
                    .frame(width: 40, height: 40)
                Button("Add to Collection") {
                    collection.addBadge(design: design, font: fontName, track: track)
                }.foregroundColor(.white)
                    .padding()
                    .background(Color.black)
                    .cornerRadius(10)
                    .font(.headline)
                if let image {
                    ShareLink(item:image, preview: SharePreview(track.name, image:image))
                }
                Spacer()
            }
        }
    }
}

extension View {
    public func asUIImage() -> UIImage {
        let controller = UIHostingController(rootView: self)
        
 // Set the background to be transparent incase the image is a PNG, WebP or (Static) GIF
        controller.view.backgroundColor = .clear
        
        controller.view.frame = CGRect(x: 0, y: CGFloat(Int.max), width: 1, height: 1)
        UIApplication.shared.windows.first!.rootViewController?.view.addSubview(controller.view)
        
        let size = controller.sizeThatFits(in: UIScreen.main.bounds.size)
        controller.view.bounds = CGRect(origin: .zero, size: size)
        controller.view.sizeToFit()
        
// here is the call to the function that converts UIView to UIImage: `.asUIImage()`
        let image = controller.view.asUIImage()
        controller.view.removeFromSuperview()
        return image
    }
    
    func UIsnapshot() -> UIImage {
        let controller = UIHostingController(rootView: self)
        let view = controller.view

        let targetSize = controller.view.intrinsicContentSize
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear

        // This forces the view to layout now
        controller.view.layoutIfNeeded()

        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
    func snapshot() -> Image {
        // Create a UIHostingController to render the SwiftUI view.
        let controller = UIHostingController(rootView: self.edgesIgnoringSafeArea(.all))
        controller.view.bounds = CGRect(origin: .zero, size: controller.view.intrinsicContentSize)
        controller.view.backgroundColor = .clear

        // Force the view to layout its subviews, essential for an accurate snapshot.
        controller.view.layoutIfNeeded()

        // Create a renderer to generate a UIImage.
        let renderer = UIGraphicsImageRenderer(bounds: controller.view.bounds)
        let uiImage = renderer.image { _ in
            controller.view.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }

        // Convert the UIImage to a SwiftUI Image and return it.
        return Image(uiImage: uiImage)
    }
}

extension UIView {
// This is the function to convert UIView to UIImage
    public func asUIImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
